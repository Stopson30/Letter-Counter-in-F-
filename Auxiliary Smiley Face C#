using System;
using System.Linq;
using System.Threading.Tasks;
using GraphQL;
using GraphQL.Client.Http;
using GraphQL.Client.Serializer.Newtonsoft;

public static class GraphQLMutation
{
    public static string AddSmileyFacesToLongSentences(string sentence)
    {
        return sentence.Length > 22 ? $"{sentence} 😊" : sentence;
    }

    public async Task<string> UpdateSentenceWithSmileyFaceAsync(string sentenceId, string originalSentence)
    {
        var modifiedSentence = AddSmileyFacesToLongSentences(originalSentence);
        
        // Assuming you have a GraphQLClient instance set up as 'client'
        var client = new GraphQLHttpClient("https://your-graphql-endpoint.com/graphql", new NewtonsoftJsonSerializer());
        var mutation = new GraphQLRequest
        {
            Query = @"
                mutation UpdateSentence($id: ID!, $text: String!) {
                    updateSentence(id: $id, text: $text) {
                        id
                        text
                    }
                }
            ",
            Variables = new
            {
                id = sentenceId,
                text = modifiedSentence
            }
        };

        var response = await client.SendMutationAsync(mutation);
        return response.Data.updateSentence.text;
    }
}
