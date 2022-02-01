Use the dataset named senators.json. In this Pset we will use all your learnings about creating a database from flat files.

1.	Before you can start loading the data in a db, you will need to do some sanity check. In the ‘objects’ key of the json, verify the following things:

(a)	The length of the ‘objects’ key
(b)	If the keys in all the ‘objects’ are same. 

2.	Now once you have figured out the consistency of the keys in all the items in ‘objects’. Using a json visualizer such as http://jsonviewer.stack.hu, do a sanity check of the data. If you were to store this data in the db, how many tables would you consider to create (Subjective question)
3.	Now check if the ‘person’ key in the ‘objects’ has consistent structure? Also check for the ‘extra’ key in the ‘objects’
4.	Now find out what is the exhaustive list of fields in the ‘extra’ key in all the ‘objects’. (Hint: use sets to get a union of all these fields)
5.	Now define the schema of the tables with relevant columns and foreign key constraints.
