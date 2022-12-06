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

    remote string function spaceByCase(required string name) {
        var output = "";
        var prevCharIsUpper = false;

        for (var i = 1; i <= len(arguments.name); i++) {
            if (i != 1 && reFind("[A-Z]", arguments.name[i]) && !prevCharIsUpper) {
                output &= " #arguments.name[i]#";
                prevCharIsUpper = true;
            } else {
                output &= arguments.name[i];
                prevCharIsUpper = false;
            }
        }

        return output;
    }

}