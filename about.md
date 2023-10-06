## About the Model

AERO (AI Evaluation of Renogram Obstruction) is a machine-learning powered model which determines the likelihood of a diuretic renogram demonstrating obstruction (defined as T-1/2 > 20 minutes) and risk of requiring pyeloplasty within 3 months. The model uses basic sonographic findings available on any ultrasound report, including anteroposterior diameter (APD), Society of Fetl Urology (SFU) grade for hydronephrosis, and kidney length. ALong with this, patient age and sex are required. The model was optimized for sensitivity, with the goal of determining whether diuretic renography could be safely avoided.

The model was trained on an isolated hydronephrosis dataset at the Hospital for Sick Children (Toronto, ON) and used random forest classification. 

## Model Performance

Performance for predicting obstruction: AUROC = 0.84, AURPC = 0.97
Performance for predicting pyeloplasty within 3 months: AUROC = 0.79, AURPC = 0.94

## Reference

<b> A machine learning tool to determine obstruction in children with hydronephrosis from simple sonographic findings. </b>  <br>
<i> Khondker A., Kwong JCC., ..., Rickard M., Lorenzo AJ. (in preparation) </i>