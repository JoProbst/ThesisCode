# Implicit Evaluation of Health Answers from Large Language Models
This repository contains the code used in my Master's thesis. 
It is structured as follows:
- `dataset/`: Contains the code used to create the dataset used in the thesis. It also contains the dataset itself and a jupyter notebook to explore it.
- `evaluation/`: Contains code to calculate scores for externally generated rankings, in this case for ColBERTv2.
- `external_scores/`: Contains the notebook used to generate the readability and credibility scores for the dataset, including an analysis of the scores.
- `generate_llm_answers/`: Contains the code to generate answers from the large language models, either with the HuggingFace pipeline or with the OpenAI API.
- `indexing/`: Contains the code to index the dataset with the different retrieval models used in the thesis. Indexing can be done without any generated LLM answers to evaluate the retrieval models on their own, or with the generated LLM answers to generate rankings for the implicit evaluation.
- `visualizations/`: Contains the notebook used to generate the visualizations used in the thesis.