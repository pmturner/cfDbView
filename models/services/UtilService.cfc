component accessors="true" singleton {

    public array function queryToArray(required query query) {
        var output = [];

        local.columns = listToArray(arguments.query.columnList);

        for (var item in arguments.query) {
            local.outputStruct = {};

            for (var column in local.columns) {
                local.structLine = {
                    "#column#": item[column]
                };

                structAppend(local.outputStruct, local.structLine)
            }

            arrayAppend(output, local.outputStruct);
        }

        return output;
    }

}