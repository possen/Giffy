# Giffy

## This project demonstrates the following:

- Querying Giphy to search for items based upon a keyword.
- Utilizes the Swift 4 facility to decode the JSON directly into objects.
- Demonstrates results paging, based upon a sparse set of data.
- Utilizes the Swift 4 zip facility and unbound ranges to insert items into the sparse dictionary(array) by using merge to insert new items into dictionary.
- An autocomplete facility which changes and filters based upon what letters are typed (currently a hard coded list).   
- Demonstrates a in memory cache for keeping images around, or purging when max memory is reached.
- Use of Adaptors to keep the reponsibilities of the objects limited and avoid the MassivViewController antipattern.
