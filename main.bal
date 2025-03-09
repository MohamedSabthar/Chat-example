import ballerinax/ai.agent;

configurable string apiKey = ?;
configurable string deploymentId = ?;
configurable string apiVersion = ?;
configurable string serviceUrl = ?;

final agent:SystemPrompt systemPrompt = {
    role: "Telegram Assistant",
    instructions: "Assist the users with their requests, whether it's for information, " +
            "tasks, or troubleshooting. Provide clear, helpful responses in a friendly and professional manner."
};
final agent:Model model = check new agent:AzureOpenAiModel(serviceUrl, apiKey, deploymentId, apiVersion);
final agent:Agent agent = check new (systemPrompt = systemPrompt, model = model,
    tools = [getUsers, getUser, getUsersPosts, getsPosts, createUser, createPost, deleteUser]
);

service on new agent:Listener(8090) {
    remote function onChatMessage(agent:ChatReqMessage request) returns agent:ChatRespMessage|error {
        string response = check agent->run(request.message, memoryId = request.sessionId);
        return {message: response};
    }
}
