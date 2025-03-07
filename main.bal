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
final agent:Model model = check new agent:AzureOpenAiModel({auth: {apiKey}}, serviceUrl, deploymentId, apiVersion);

final map<agent:Agent> sessions = {};

service on new agent:Listener(8090) {
    remote function onChatMessage(agent:ChatReqMessage request) returns agent:ChatRespMessage|error {
        if !sessions.hasKey(request.sessionId) {
            agent:Agent agent = check new (systemPrompt = systemPrompt, model = model,
                tools = [getUsers, getUser, getUsersPosts, getsPosts, createUser, createPost, deleteUser],
                memory = new agent:MessageWindowChatMemory(20)
            );
            sessions[request.sessionId] = agent;
        }
        agent:Agent agent = sessions.get(request.sessionId);
        string response = check agent->run(request.message);
        return {message: response};
    }
}
