import ballerina/time;

type User record {|
    int id;
    string name;
    time:Date birthDate;
    string mobileNumber;
|};

type Post record {|
    int id;
    string description;
    string author;
    record {|
        string[] tags;
        string category;
        time:Civil createdTimeStamp;
    |} meta;
|};

public type NewUser record {|
    string name;
    time:Date birthDate;
    string mobileNumber;
|};

public type NewPost record {|
    string description;
    string tags;
    string category;
|};