# %%
from transformers import AutoTokenizer, AutoModelForSequenceClassification
import torch

model = AutoModelForSequenceClassification.from_pretrained("huggingface_checkpoint_pointwise_crossencoder",cache_dir="./", local_files_only=True)
tokenizer = AutoTokenizer.from_pretrained("huggingface_checkpoint_pointwise_crossencoder",cache_dir="./", local_files_only=True)

# %%
# check gpu availability
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)

# %%
import xml.etree.ElementTree as ET
import pandas as pd

def load_topics(path):
    with open(path) as f:
        root = ET.fromstring(f.read())
    topic_dict = {}
    for topic in root.findall("topic"):
        topic_id = topic.findtext("id")
        topic_query = topic.findtext("query")
        if topic_id and topic_query:
            topic_dict[topic_id] = topic_query.strip().lower()
    topics = pd.DataFrame(topic_dict.items(), columns=["qid", "query"]) 
    topics["query"] = topics["query"].str.replace(r'\W+', ' ', regex=True)
    return topics

# %%
all_passages = pd.read_csv("data/Webdoc/txt.tsv", sep="\t", nrows=100)


# %%
topics = load_topics("data/topics/topics.txt")

# %%
# for a given topic, encode the query and all passages
# to model takes inputs in shape [cls] topic [sep] doc [sep]
# directly use the huggingface library to encode the query and passages

def encode_topic_passages(topic_id):
    topic = topics[topics["qid"] == topic_id]["query"].values[0]
    passages = all_passages["text"].values
    inputs = tokenizer.batch_encode_plus([[topic, passage] for passage in passages], return_tensors="pt", pad_to_max_length=True, max_length=512, truncation=True)
    return inputs

# get the top n passages for a given topic
def get_top_n(topic_id, n):
    inputs = encode_topic_passages(topic_id)
    outputs = model(**inputs)
    logits = outputs.logits
    probs = torch.softmax(logits, dim=1)
    probs = probs[:, 1]
    top_n = torch.topk(probs, n)
    top_indices = top_n.indices.tolist()
    top_n_passages = [all_passages.iloc[i]["text"] for i in top_indices]
    top_n_scores = top_n.values
    return top_n_passages, top_n_scores


# get the top 10 passages for topic 1
inputs = encode_topic_passages("1")

# %%
passages, scores = get_top_n("1", 10)

# %%
topic = topics[topics["qid"] == "1"]["query"].values[0]

# %%
topic

# %%
passages


