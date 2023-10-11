//输入名称，替换
/*用法
            var usernamepr = {};
            usernamepr.serviceUrl = "GetUserForSearch.ashx?OperationType=droplist&fields=U_ID,PI_CODE,U_NAME"; //  + "?OperationType=detail&id=" + id + "&fields=" + fields;
            usernamepr.ControldId = "#username";
            usernamepr.TextField = "U_NAME";
            usernamepr.ValueField = "U_ID";
            usernamepr.onSelect = function (suggestion) {
                U_ID = suggestion.data;
              //  $('#calendar').fullCalendar('refetchEvents');
               // getinfo(U_ID);
            };       
            usernamepr.formatResult = formatResult;//可以不写
            var AutoCompleteCommonusername = new AutoCompleteCommon(usernamepr);
            AutoCompleteCommonusername.init();

*/

function AutoCompleteCommon(obj) {
    this.serviceUrl = obj.serviceUrl;
    this.ControldId = obj.ControldId;
    this.TextField = obj.TextField;
    this.ValueField = obj.ValueField;
    this.onSelect = obj.onSelect;
    this.onSearchComplete = obj.onSearchComplete;
    if (obj.formatResult) {
        this.formatResult = obj.formatResult;
     }  
}
AutoCompleteCommon.prototype.init = function () {
    var options = {
        serviceUrl: this.serviceUrl,
        transformResult: transformResult,
        formatResult: this.formatResult,
        onSelect: this.onSelect,  
        TextField: this.TextField,
        ValueField: this.ValueField,
        onSearchComplete: this.onSearchComplete
    };
    if (this.formatResult) {
       options.formatResult = this.formatResult;
    }
    $(this.ControldId).autocomplete(options);
}

function transformResult(response) {
    var res = $.parseJSON(response);
    if (res.IsSuccess && res.IsLogin) {
        var that = this; //是Autocomplete的options
        var obj = $.parseJSON(res.Msg);
        return {
            suggestions: $.map(obj, function (dataItem) {
                var temp = { value: dataItem[that.TextField] + "", data: dataItem[that.ValueField] + "" };            
                for (var p in dataItem) {
                    var name = p; //属性名称
                    if (name !== that.TextField && name !== that.ValueField) {
                        var value = dataItem[p]; //属性对应的值
                        temp[name] = value + "";
                    }
                }
                return temp;
            })
        }//return
    }
}

