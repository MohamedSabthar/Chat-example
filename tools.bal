import ballerina/http;
import ballerinax/ai.agent;

final http:Client ripplitClient = check new ("http://localhost:9095/ripplit");

# Get all the users
# + return - An array of users or an error in case of failure
@agent:Tool
isolated function getUsers() returns User[]|error {
    return ripplitClient->/users.get();
}

# Create a new user
# + user - The details of the new user to be created
# + return - An error if the user creation fails, or nil if successful
@agent:Tool
isolated function createUser(NewUser user) returns anydata|error {
    return ripplitClient->/users.post(user);
}

# Get a specific user
# + id - The unique ID of the user to retrieve
# + return - A user object if found, or an error if not found
@agent:Tool
isolated function getUser(int id) returns User|error {
    return ripplitClient->/users/[id].get();
}

# Delete a user
# + id - The unique ID of the user to be deleted
# + return - An error if the deletion fails, or nil if successful
@agent:Tool
isolated function deleteUser(int id) returns anydata|error {
    return ripplitClient->/users/[id].delete();
}

# Get posts for a given user
# + id - The user ID for whom the posts are to be retrieved
# + return - An array of posts made by the user, or an error if retrieval fails
@agent:Tool
isolated function getUsersPosts(int id) returns Post[]|error {
    return ripplitClient->/users/[id]/posts.get();
}

# Get all posts
# + return - An array of all posts, or an error if retrieval fails
@agent:Tool
isolated function getsPosts() returns Post[]|error {
    return ripplitClient->/posts.get();
}

# Create a post for a given user
# + id - The user ID for whom the post is to be created
# + post - The details of the post to be created
# + return - The created post object, or an error if creation fails
@agent:Tool
isolated function createPost(int id, NewPost post) returns anydata|error {
    return ripplitClient->/users/[id]/posts.post(post);
}
