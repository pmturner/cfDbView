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

    public string function determineType(required any value) {
        var type = "string";

        if (isNumeric(arguments.value) && isValid("integer", arguments.value)) {
            type = "int";
        }
        if (isNumeric(arguments.value) && isValid("float", arguments.value)) {
            type = "float";
        }
        if (isValid("boolean", arguments.value)) {
            type = "bit";
        }
        if (isDate(arguments.value)) {
            type = "datetime";
        }
        if (isValid("date", arguments.value)) {
            type = "date";
        }

        return type;
    }

}