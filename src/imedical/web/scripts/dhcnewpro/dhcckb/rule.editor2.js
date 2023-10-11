var _json=[{"ruleId":8676,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"开医嘱提醒","variableName":"70","ruleData":"57157"},"type":"variable","ruleData":"57157"},"value":{"constantCategory":"143","constantName":"143","constantLabel":"true","valueType":"Constant","ruleData":"57157"},"op":"Equals","ruleData":"57157"}],"ruleData":44084}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"57158"},"ruleData":"57158"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"57159"},"ruleData":"57159"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"主要用于预防风湿热复发，也可用于控制链球菌感染的流行。"},"ruleData":"57160"}]},"other":{"actions":[]}}]}]
//var _json=[{"ruleId":61878,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"469247"},"type":"variable","ruleData":"469247"},"value":{"content":"2","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"469247"},"op":"Between","ruleData":"469247"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"469248"},"type":"variable","ruleData":"469248"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"469248"},"op":"LessThenEquals","ruleData":"469248"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"469249"},"type":"variable","ruleData":"469249"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"469249"},"op":"Equals","ruleData":"469249"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"469250"},"type":"variable","ruleData":"469250"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"469250"},"op":"Equals","ruleData":"469250"}],"ruleData":"345978"}],"ruleData":345977}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"469251"},"ruleData":"469251"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":138,"constantLabel":"提醒","ruleData":"469252"},"ruleData":"469252"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"一般性规则"},"ruleData":"469253"},{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"经验性用药"},"ruleData":"469254"}]},"other":{"actions":[]}}]}]
//var _json=[{"ruleId":61462,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"424779"},"type":"variable","ruleData":"424779"},"value":{"constantCategory":"3930","constantName":"3930","constantLabel":"小儿","valueType":"Constant","ruleData":"424779"},"op":"Equals","ruleData":"424779"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"424780"},"type":"variable","ruleData":"424780"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"424780"},"op":"Equals","ruleData":"424780"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"424781"},"type":"variable","ruleData":"424781"},"value":{"content":"2.5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"424781"},"op":"LessThenEquals","ruleData":"424781"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"424782"},"type":"variable","ruleData":"424782"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"424782"},"op":"Equals","ruleData":"424782"}],"ruleData":320250}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"424783"},"ruleData":"424783"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"424784"},"ruleData":"424784"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"小儿：肌内注射，按体重2.5万单位/kg，每12小时给药1次；"},"ruleData":"424785"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"424786"},"ruleData":"424786"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"424787"},"ruleData":"424787"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1108491"},"type":"variable","ruleData":"1108491"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1108491"},"op":"Equals","ruleData":"1108491"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1108492"},"type":"variable","ruleData":"1108492"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1108492"},"op":"Equals","ruleData":"1108492"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1108493"},"type":"variable","ruleData":"1108493"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1108493"},"op":"Equals","ruleData":"1108493"}],"ruleData":"820679"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1108494"},"type":"variable","ruleData":"1108494"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1108494"},"op":"Between","ruleData":"1108494"}],"ruleData":"820680"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1108495"},"type":"variable","ruleData":"1108495"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1108495"},"op":"LessThenEquals","ruleData":"1108495"}],"ruleData":"820681"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1108496"},"type":"variable","ruleData":"1108496"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1108496"},"op":"LessThenEquals","ruleData":"1108496"}],"ruleData":"820682"}],"ruleData":820678}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1108497"}]}}]}]
//var _json=[{"ruleId":61960,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"470945"},"type":"variable","ruleData":"470945"},"value":{"constantCategory":"4063","constantName":"4063","constantLabel":"口服","valueType":"Constant","ruleData":"470945"},"op":"Equals","ruleData":"470945"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"470946"},"type":"variable","ruleData":"470946"},"value":{"content":"480","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"470946"},"op":"LessThenEquals","ruleData":"470946"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"470947"},"type":"variable","ruleData":"470947"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"6","valueType":"InputLimit","ruleData":"470947"},"op":"Between","ruleData":"470947"}],"ruleData":"347101"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"470948"},"type":"variable","ruleData":"470948"},"value":{"content":"1888","contentUom":"3998","contentUomDesc":"mg","contentLimit":"","valueType":"InputUom","ruleData":"470948"},"op":"LessThenEquals","ruleData":"470948"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"470949"},"type":"variable","ruleData":"470949"},"value":{"content":"320","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"470949"},"op":"LessThenEquals","ruleData":"470949"}],"ruleData":"347102"}],"ruleData":347100}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"470950"}]}}]}]
//var _json=[{"ruleId":61961,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"454421"},"type":"variable","ruleData":"454421"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"454421"},"op":"Equals","ruleData":"454421"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"454422"},"type":"variable","ruleData":"454422"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"454422"},"op":"Equals","ruleData":"454422"}],"ruleData":"338062"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"454423"},"type":"variable","ruleData":"454423"},"value":{"constantCategory":"11335","constantName":"11335","constantLabel":"qid","valueType":"Constant","ruleData":"454423"},"op":"Equals","ruleData":"454423"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"454424"},"type":"variable","ruleData":"454424"},"value":{"constantCategory":"5724","constantName":"5724","constantLabel":"bid","valueType":"Constant","ruleData":"454424"},"op":"Equals","ruleData":"454424"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"454425"},"type":"variable","ruleData":"454425"},"value":{"constantCategory":"4096","constantName":"4096","constantLabel":"q6h","valueType":"Constant","ruleData":"454425"},"op":"Equals","ruleData":"454425"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"454426"},"type":"variable","ruleData":"454426"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"454426"},"op":"Equals","ruleData":"454426"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"454427"},"type":"variable","ruleData":"454427"},"value":{"constantCategory":"4103","constantName":"4103","constantLabel":"q8h","valueType":"Constant","ruleData":"454427"},"op":"Equals","ruleData":"454427"}],"ruleData":"338063"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"454428"},"type":"variable","ruleData":"454428"},"value":{"content":"12.5","contentUom":"3931","contentUomDesc":"mg/kg","contentLimit":"25","valueType":"InputLimit","ruleData":"454428"},"op":"Between","ruleData":"454428"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"454429"},"type":"variable","ruleData":"454429"},"value":{"content":"25","contentUom":"3931","contentUomDesc":"mg/kg","contentLimit":"","valueType":"InputUom","ruleData":"454429"},"op":"LessThenEquals","ruleData":"454429"}],"ruleData":"338064"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"454430"},"type":"variable","ruleData":"454430"},"value":{"content":"4","contentUom":"3924","contentUomDesc":"g","contentLimit":"6","valueType":"InputLimit","ruleData":"454430"},"op":"Between","ruleData":"454430"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"454431"},"type":"variable","ruleData":"454431"},"value":{"content":"4","contentUom":"3924","contentUomDesc":"g","contentLimit":"8","valueType":"InputLimit","ruleData":"454431"},"op":"Between","ruleData":"454431"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"454432"},"type":"variable","ruleData":"454432"},"value":{"content":"12","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"454432"},"op":"LessThenEquals","ruleData":"454432"}],"ruleData":"338065"}],"ruleData":338061}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"454433"}]}}]}]
//var _json=[{"ruleId":61904,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"or","criterions":[{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"774557"},"type":"variable","ruleData":"774557"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"","valueType":"InputUom","ruleData":"774557"},"op":"LessThenEquals","ruleData":"774557"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"774558"},"type":"variable","ruleData":"774558"},"value":{"content":"4","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"774558"},"op":"LessThenEquals","ruleData":"774558"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"774559"},"type":"variable","ruleData":"774559"},"value":{"constantCategory":"4063","constantName":"4063","constantLabel":"口服","valueType":"Constant","ruleData":"774559"},"op":"Equals","ruleData":"774559"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"774560"},"type":"variable","ruleData":"774560"},"value":{"constantCategory":"7591","constantName":"7591","constantLabel":"冲服","valueType":"Constant","ruleData":"774560"},"op":"Equals","ruleData":"774560"}],"ruleData":"570457"}],"ruleData":"570456"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"774561"},"type":"variable","ruleData":"774561"},"value":{"content":"4","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"774561"},"op":"LessThenEquals","ruleData":"774561"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"774562"},"type":"variable","ruleData":"774562"},"value":{"content":"3","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"","valueType":"InputUom","ruleData":"774562"},"op":"LessThenEquals","ruleData":"774562"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"774563"},"type":"variable","ruleData":"774563"},"value":{"constantCategory":"4063","constantName":"4063","constantLabel":"口服","valueType":"Constant","ruleData":"774563"},"op":"Equals","ruleData":"774563"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"774564"},"type":"variable","ruleData":"774564"},"value":{"constantCategory":"7591","constantName":"7591","constantLabel":"冲服","valueType":"Constant","ruleData":"774564"},"op":"Equals","ruleData":"774564"}],"ruleData":"570459"}],"ruleData":"570458"}],"ruleData":570455}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"774565"},"ruleData":"774565"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":138,"constantLabel":"提醒","ruleData":"774566"},"ruleData":"774566"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"一般性规则"},"ruleData":"774567"},{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"经验性用药"},"ruleData":"774568"}]},"other":{"actions":[]}}]}]
//var _json=[{"ruleId":61976,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186321"},"type":"variable","ruleData":"1186321"},"value":{"constantCategory":"4098","constantName":"4098","constantLabel":"静脉注射","valueType":"Constant","ruleData":"1186321"},"op":"Equals","ruleData":"1186321"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186322"},"type":"variable","ruleData":"1186322"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1186322"},"op":"Equals","ruleData":"1186322"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186323"},"type":"variable","ruleData":"1186323"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1186323"},"op":"Equals","ruleData":"1186323"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186324"},"type":"variable","ruleData":"1186324"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186324"},"op":"Equals","ruleData":"1186324"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186325"},"type":"variable","ruleData":"1186325"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186325"},"op":"Equals","ruleData":"1186325"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186326"},"type":"variable","ruleData":"1186326"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186326"},"op":"Equals","ruleData":"1186326"}],"ruleData":"879042"}],"ruleData":"879041"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1186327"},"type":"variable","ruleData":"1186327"},"value":{"content":"3","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"6","valueType":"InputLimit","ruleData":"1186327"},"op":"Between","ruleData":"1186327"}],"ruleData":"879043"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1186328"},"type":"variable","ruleData":"1186328"},"value":{"content":"2.0","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1186328"},"op":"LessThenEquals","ruleData":"1186328"}],"ruleData":"879044"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1186329"},"type":"variable","ruleData":"1186329"},"value":{"content":"12","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1186329"},"op":"LessThenEquals","ruleData":"1186329"}],"ruleData":"879045"}],"ruleData":879040}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1186330"}]}}]}]
//var _json=[{"ruleId":61976,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186434"},"type":"variable","ruleData":"1186434"},"value":{"constantCategory":"4098","constantName":"4098","constantLabel":"静脉注射","valueType":"Constant","ruleData":"1186434"},"op":"Equals","ruleData":"1186434"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186435"},"type":"variable","ruleData":"1186435"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1186435"},"op":"Equals","ruleData":"1186435"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1186436"},"type":"variable","ruleData":"1186436"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1186436"},"op":"Equals","ruleData":"1186436"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186437"},"type":"variable","ruleData":"1186437"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186437"},"op":"Equals","ruleData":"1186437"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186438"},"type":"variable","ruleData":"1186438"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186438"},"op":"Equals","ruleData":"1186438"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186439"},"type":"variable","ruleData":"1186439"},"value":{"content":"2","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186439"},"op":"Equals","ruleData":"1186439"}],"ruleData":"879133"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186440"},"type":"variable","ruleData":"1186440"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186440"},"op":"Equals","ruleData":"1186440"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1186441"},"type":"variable","ruleData":"1186441"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1186441"},"op":"Equals","ruleData":"1186441"}],"ruleData":"879134"}],"ruleData":"879132"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1186442"},"type":"variable","ruleData":"1186442"},"value":{"content":"3","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"6","valueType":"InputLimit","ruleData":"1186442"},"op":"Between","ruleData":"1186442"}],"ruleData":"879135"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1186443"},"type":"variable","ruleData":"1186443"},"value":{"content":"2.0","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1186443"},"op":"LessThenEquals","ruleData":"1186443"}],"ruleData":"879136"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1186444"},"type":"variable","ruleData":"1186444"},"value":{"content":"12","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1186444"},"op":"LessThenEquals","ruleData":"1186444"}],"ruleData":"879137"}],"ruleData":879131}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1186445"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188200"},"type":"variable","ruleData":"1188200"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1188200"},"op":"Equals","ruleData":"1188200"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188201"},"type":"variable","ruleData":"1188201"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1188201"},"op":"Equals","ruleData":"1188201"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188202"},"type":"variable","ruleData":"1188202"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1188202"},"op":"Equals","ruleData":"1188202"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188205"},"type":"variable","ruleData":"1188205"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188205"},"op":"Equals","ruleData":"1188205"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188203"},"type":"variable","ruleData":"1188203"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188203"},"op":"Equals","ruleData":"1188203"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188204"},"type":"variable","ruleData":"1188204"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188204"},"op":"Equals","ruleData":"1188204"}],"ruleData":"880405"}],"ruleData":"880404"}],"ruleData":"880403"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1188206"},"type":"variable","ruleData":"1188206"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1188206"},"op":"Between","ruleData":"1188206"}],"ruleData":"880406"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1188207"},"type":"variable","ruleData":"1188207"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1188207"},"op":"LessThenEquals","ruleData":"1188207"}],"ruleData":"880407"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1188208"},"type":"variable","ruleData":"1188208"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1188208"},"op":"LessThenEquals","ruleData":"1188208"}],"ruleData":"880408"}],"ruleData":880402}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1188209"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188234"},"type":"variable","ruleData":"1188234"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1188234"},"op":"Equals","ruleData":"1188234"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188235"},"type":"variable","ruleData":"1188235"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1188235"},"op":"Equals","ruleData":"1188235"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1188236"},"type":"variable","ruleData":"1188236"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1188236"},"op":"Equals","ruleData":"1188236"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188237"},"type":"variable","ruleData":"1188237"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188237"},"op":"Equals","ruleData":"1188237"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188238"},"type":"variable","ruleData":"1188238"},"value":{"content":"2","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188238"},"op":"Equals","ruleData":"1188238"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188239"},"type":"variable","ruleData":"1188239"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188239"},"op":"Equals","ruleData":"1188239"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188240"},"type":"variable","ruleData":"1188240"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188240"},"op":"Equals","ruleData":"1188240"}],"ruleData":"880430"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188241"},"type":"variable","ruleData":"1188241"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188241"},"op":"Equals","ruleData":"1188241"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188242"},"type":"variable","ruleData":"1188242"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188242"},"op":"Equals","ruleData":"1188242"}],"ruleData":"880431"}],"ruleData":"880429"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188243"},"type":"variable","ruleData":"1188243"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188243"},"op":"Equals","ruleData":"1188243"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1188244"},"type":"variable","ruleData":"1188244"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1188244"},"op":"Equals","ruleData":"1188244"}],"ruleData":"880432"}],"ruleData":"880428"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1188245"},"type":"variable","ruleData":"1188245"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1188245"},"op":"Between","ruleData":"1188245"}],"ruleData":"880433"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1188246"},"type":"variable","ruleData":"1188246"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1188246"},"op":"LessThenEquals","ruleData":"1188246"}],"ruleData":"880434"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1188247"},"type":"variable","ruleData":"1188247"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1188247"},"op":"LessThenEquals","ruleData":"1188247"}],"ruleData":"880435"}],"ruleData":880427}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1188248"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1192267"},"type":"variable","ruleData":"1192267"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1192267"},"op":"Equals","ruleData":"1192267"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1192268"},"type":"variable","ruleData":"1192268"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1192268"},"op":"Equals","ruleData":"1192268"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1192269"},"type":"variable","ruleData":"1192269"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1192269"},"op":"Equals","ruleData":"1192269"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192270"},"type":"variable","ruleData":"1192270"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192270"},"op":"Equals","ruleData":"1192270"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192271"},"type":"variable","ruleData":"1192271"},"value":{"content":"2","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192271"},"op":"Equals","ruleData":"1192271"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192272"},"type":"variable","ruleData":"1192272"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192272"},"op":"Equals","ruleData":"1192272"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192273"},"type":"variable","ruleData":"1192273"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192273"},"op":"Equals","ruleData":"1192273"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192274"},"type":"variable","ruleData":"1192274"},"value":{"content":"0","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192274"},"op":"Equals","ruleData":"1192274"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192275"},"type":"variable","ruleData":"1192275"},"value":{"content":"0","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192275"},"op":"Equals","ruleData":"1192275"}],"ruleData":"883498"}],"ruleData":"883497"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192276"},"type":"variable","ruleData":"1192276"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192276"},"op":"Equals","ruleData":"1192276"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192277"},"type":"variable","ruleData":"1192277"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192277"},"op":"Equals","ruleData":"1192277"}],"ruleData":"883499"}],"ruleData":"883496"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192278"},"type":"variable","ruleData":"1192278"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192278"},"op":"Equals","ruleData":"1192278"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1192279"},"type":"variable","ruleData":"1192279"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1192279"},"op":"Equals","ruleData":"1192279"}],"ruleData":"883500"}],"ruleData":"883495"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1192280"},"type":"variable","ruleData":"1192280"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1192280"},"op":"Between","ruleData":"1192280"}],"ruleData":"883501"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1192281"},"type":"variable","ruleData":"1192281"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1192281"},"op":"LessThenEquals","ruleData":"1192281"}],"ruleData":"883502"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1192282"},"type":"variable","ruleData":"1192282"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1192282"},"op":"LessThenEquals","ruleData":"1192282"}],"ruleData":"883503"}],"ruleData":883494}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1192283"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1203608"},"type":"variable","ruleData":"1203608"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1203608"},"op":"Equals","ruleData":"1203608"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1203609"},"type":"variable","ruleData":"1203609"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1203609"},"op":"Equals","ruleData":"1203609"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1203610"},"type":"variable","ruleData":"1203610"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1203610"},"op":"Equals","ruleData":"1203610"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203611"},"type":"variable","ruleData":"1203611"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203611"},"op":"GreaterThen","ruleData":"1203611"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203612"},"type":"variable","ruleData":"1203612"},"value":{"content":"2","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203612"},"op":"GreaterThenEquals","ruleData":"1203612"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203613"},"type":"variable","ruleData":"1203613"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203613"},"op":"LessThen","ruleData":"1203613"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203614"},"type":"variable","ruleData":"1203614"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203614"},"op":"NotEquals","ruleData":"1203614"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203615"},"type":"variable","ruleData":"1203615"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203615"},"op":"In","ruleData":"1203615"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203616"},"type":"variable","ruleData":"1203616"},"value":{"content":"0","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203616"},"op":"Equals","ruleData":"1203616"}],"ruleData":"892463"}],"ruleData":"892462"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203617"},"type":"variable","ruleData":"1203617"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203617"},"op":"Equals","ruleData":"1203617"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203618"},"type":"variable","ruleData":"1203618"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203618"},"op":"Equals","ruleData":"1203618"}],"ruleData":"892464"}],"ruleData":"892461"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203619"},"type":"variable","ruleData":"1203619"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203619"},"op":"Equals","ruleData":"1203619"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1203620"},"type":"variable","ruleData":"1203620"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1203620"},"op":"Equals","ruleData":"1203620"}],"ruleData":"892465"}],"ruleData":"892460"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1203621"},"type":"variable","ruleData":"1203621"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1203621"},"op":"Between","ruleData":"1203621"}],"ruleData":"892466"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1203622"},"type":"variable","ruleData":"1203622"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1203622"},"op":"LessThenEquals","ruleData":"1203622"}],"ruleData":"892467"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1203623"},"type":"variable","ruleData":"1203623"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1203623"},"op":"LessThenEquals","ruleData":"1203623"}],"ruleData":"892468"}],"ruleData":892459}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1203624"}]}}]}]
//var _json=[{"ruleId":61958,"alone":true,"rules":[{"name":"普适规则","remark":"系统生成","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204960"},"type":"variable","ruleData":"1204960"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1204960"},"op":"Equals","ruleData":"1204960"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204961"},"type":"variable","ruleData":"1204961"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1204961"},"op":"Equals","ruleData":"1204961"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204962"},"type":"variable","ruleData":"1204962"},"value":{"constantCategory":"13295","constantName":"13295","constantLabel":"皮内注射","valueType":"Constant","ruleData":"1204962"},"op":"Equals","ruleData":"1204962"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204963"},"type":"variable","ruleData":"1204963"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204963"},"op":"GreaterThen","ruleData":"1204963"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204964"},"type":"variable","ruleData":"1204964"},"value":{"content":"2","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204964"},"op":"GreaterThenEquals","ruleData":"1204964"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204965"},"type":"variable","ruleData":"1204965"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204965"},"op":"LessThen","ruleData":"1204965"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204966"},"type":"variable","ruleData":"1204966"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204966"},"op":"NotEquals","ruleData":"1204966"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204967"},"type":"variable","ruleData":"1204967"},"value":{"content":"1","contentUom":"3933","contentUomDesc":"min","contentLimit":"2","valueType":"InputLimit","ruleData":"1204967"},"op":"In","ruleData":"1204967"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204968"},"type":"variable","ruleData":"1204968"},"value":{"content":"0","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204968"},"op":"Equals","ruleData":"1204968"}],"ruleData":"893447"}],"ruleData":"893446"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204969"},"type":"variable","ruleData":"1204969"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204969"},"op":"Equals","ruleData":"1204969"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204970"},"type":"variable","ruleData":"1204970"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204970"},"op":"Equals","ruleData":"1204970"}],"ruleData":"893448"}],"ruleData":"893445"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204971"},"type":"variable","ruleData":"1204971"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204971"},"op":"Equals","ruleData":"1204971"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1204972"},"type":"variable","ruleData":"1204972"},"value":{"content":"4","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1204972"},"op":"Equals","ruleData":"1204972"}],"ruleData":"893449"}],"ruleData":"893444"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1204973"},"type":"variable","ruleData":"1204973"},"value":{"content":"1","contentUom":"49881","contentUomDesc":"次/日","contentLimit":"4","valueType":"InputLimit","ruleData":"1204973"},"op":"Between","ruleData":"1204973"}],"ruleData":"893450"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1204974"},"type":"variable","ruleData":"1204974"},"value":{"content":"1000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1204974"},"op":"LessThenEquals","ruleData":"1204974"}],"ruleData":"893451"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1204975"},"type":"variable","ruleData":"1204975"},"value":{"content":"2000","contentUom":"50028","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1204975"},"op":"LessThenEquals","ruleData":"1204975"}],"ruleData":"893452"}],"ruleData":893443}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1204976"}]}}]}]
//两层1并且2或者
var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1204538"},"type":"variable","ruleData":"1204538"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1204538"},"op":"Equals","ruleData":"1204538"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1204539"},"type":"variable","ruleData":"1204539"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1204539"},"op":"Equals","ruleData":"1204539"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1204540"},"type":"variable","ruleData":"1204540"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1204540"},"op":"LessThenEquals","ruleData":"1204540"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1204541"},"type":"variable","ruleData":"1204541"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1204541"},"op":"Equals","ruleData":"1204541"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204542"},"type":"variable","ruleData":"1204542"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1204542"},"op":"Equals","ruleData":"1204542"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1204543"},"type":"variable","ruleData":"1204543"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1204543"},"op":"Equals","ruleData":"1204543"}],"ruleData":"893137"}],"ruleData":893136}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1204544"},"ruleData":"1204544"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1204545"},"ruleData":"1204545"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1204546"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1204547"},"ruleData":"1204547"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1204548"},"ruleData":"1204548"}]}}]}]
//两层1并且2或者并且var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1451597"},"type":"variable","ruleData":"1451597"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1451597"},"op":"Equals","ruleData":"1451597"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1451598"},"type":"variable","ruleData":"1451598"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1451598"},"op":"Equals","ruleData":"1451598"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1451599"},"type":"variable","ruleData":"1451599"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1451599"},"op":"LessThenEquals","ruleData":"1451599"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1451600"},"type":"variable","ruleData":"1451600"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1451600"},"op":"Equals","ruleData":"1451600"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451601"},"type":"variable","ruleData":"1451601"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1451601"},"op":"Equals","ruleData":"1451601"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451602"},"type":"variable","ruleData":"1451602"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1451602"},"op":"Equals","ruleData":"1451602"}],"ruleData":"1039525"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451603"},"type":"variable","ruleData":"1451603"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451603"},"op":"Equals","ruleData":"1451603"}],"ruleData":"1039526"}],"ruleData":1039524}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1451604"},"ruleData":"1451604"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451605"},"ruleData":"1451605"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1451606"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1451607"},"ruleData":"1451607"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451608"},"ruleData":"1451608"}]}}]}]
//三层
//var _json=[{"ruleId":192430,"alone":true,"rules":[{"name":"rule","remark":"复制规则","lhs":{"criterion":{"junctionType":"and","criterions":[{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463182"},"type":"variable","ruleData":"1463182"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1463182"},"op":"Equals","ruleData":"1463182"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463183"},"type":"variable","ruleData":"1463183"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1463183"},"op":"Equals","ruleData":"1463183"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463184"},"type":"variable","ruleData":"1463184"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463184"},"op":"GreaterThen","ruleData":"1463184"}],"ruleData":"1047596"}],"ruleData":"1047595"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463185"},"type":"variable","ruleData":"1463185"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1463185"},"op":"Equals","ruleData":"1463185"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463186"},"type":"variable","ruleData":"1463186"},"value":{"constantCategory":"4096","constantName":"4096","constantLabel":"q6h","valueType":"Constant","ruleData":"1463186"},"op":"Equals","ruleData":"1463186"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463187"},"type":"variable","ruleData":"1463187"},"value":{"constantCategory":"5724","constantName":"5724","constantLabel":"bid","valueType":"Constant","ruleData":"1463187"},"op":"Equals","ruleData":"1463187"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463188"},"type":"variable","ruleData":"1463188"},"value":{"constantCategory":"5642","constantName":"5642","constantLabel":"tid","valueType":"Constant","ruleData":"1463188"},"op":"Equals","ruleData":"1463188"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463189"},"type":"variable","ruleData":"1463189"},"value":{"constantCategory":"11335","constantName":"11335","constantLabel":"qid","valueType":"Constant","ruleData":"1463189"},"op":"Equals","ruleData":"1463189"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463190"},"type":"variable","ruleData":"1463190"},"value":{"constantCategory":"4103","constantName":"4103","constantLabel":"q8h","valueType":"Constant","ruleData":"1463190"},"op":"Equals","ruleData":"1463190"}],"ruleData":"1047597"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1463191"},"type":"variable","ruleData":"1463191"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1463191"},"op":"LessThenEquals","ruleData":"1463191"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"每日用药量","variableName":"52","ruleData":"1463192"},"type":"variable","ruleData":"1463192"},"value":{"content":"2000","contentUom":"7288","contentUomDesc":"万单位","contentLimit":"","valueType":"InputUom","ruleData":"1463192"},"op":"LessThenEquals","ruleData":"1463192"}],"ruleData":"1047598"}],"ruleData":1047594}},"rhs":{"actions":[]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":84,"variableLabel":"提示依据","variableCategory":"输出属性","variableCategoryId":21,"value":{"valueType":"Input","content":"系统生成"},"ruleData":"1463193"}]}}]}]
//三层1并且2或者或者并且3并且
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1451630"},"type":"variable","ruleData":"1451630"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1451630"},"op":"Equals","ruleData":"1451630"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1451631"},"type":"variable","ruleData":"1451631"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1451631"},"op":"Equals","ruleData":"1451631"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1451632"},"type":"variable","ruleData":"1451632"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1451632"},"op":"LessThenEquals","ruleData":"1451632"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1451633"},"type":"variable","ruleData":"1451633"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1451633"},"op":"Equals","ruleData":"1451633"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451634"},"type":"variable","ruleData":"1451634"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1451634"},"op":"Equals","ruleData":"1451634"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451635"},"type":"variable","ruleData":"1451635"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1451635"},"op":"Equals","ruleData":"1451635"}],"ruleData":"1039548"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451636"},"type":"variable","ruleData":"1451636"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451636"},"op":"Equals","ruleData":"1451636"}],"ruleData":"1039549"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451637"},"type":"variable","ruleData":"1451637"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451637"},"op":"Equals","ruleData":"1451637"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451638"},"type":"variable","ruleData":"1451638"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451638"},"op":"Equals","ruleData":"1451638"}],"ruleData":"1039551"}],"ruleData":"1039550"}],"ruleData":1039547}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1451639"},"ruleData":"1451639"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451640"},"ruleData":"1451640"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1451641"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1451642"},"ruleData":"1451642"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451643"},"ruleData":"1451643"}]}}]}]
//三层1并且2并且并且或者联合3并且
var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1451811"},"type":"variable","ruleData":"1451811"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1451811"},"op":"Equals","ruleData":"1451811"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1451812"},"type":"variable","ruleData":"1451812"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1451812"},"op":"Equals","ruleData":"1451812"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1451813"},"type":"variable","ruleData":"1451813"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1451813"},"op":"LessThenEquals","ruleData":"1451813"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1451814"},"type":"variable","ruleData":"1451814"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1451814"},"op":"Equals","ruleData":"1451814"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451815"},"type":"variable","ruleData":"1451815"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1451815"},"op":"Equals","ruleData":"1451815"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451816"},"type":"variable","ruleData":"1451816"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1451816"},"op":"Equals","ruleData":"1451816"}],"ruleData":"1039673"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451817"},"type":"variable","ruleData":"1451817"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451817"},"op":"Equals","ruleData":"1451817"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451818"},"type":"variable","ruleData":"1451818"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451818"},"op":"Equals","ruleData":"1451818"}],"ruleData":"1039675"}],"ruleData":"1039674"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451819"},"type":"variable","ruleData":"1451819"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451819"},"op":"Equals","ruleData":"1451819"}],"ruleData":"1039676"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451820"},"type":"variable","ruleData":"1451820"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451820"},"op":"Equals","ruleData":"1451820"}],"ruleData":"1039677"}],"ruleData":1039672}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1451821"},"ruleData":"1451821"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451822"},"ruleData":"1451822"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1451823"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1451824"},"ruleData":"1451824"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451825"},"ruleData":"1451825"}]}}]}]
//四层1并且2并且并且或者联合3并且4并且
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1451826"},"type":"variable","ruleData":"1451826"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1451826"},"op":"Equals","ruleData":"1451826"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1451827"},"type":"variable","ruleData":"1451827"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1451827"},"op":"Equals","ruleData":"1451827"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1451828"},"type":"variable","ruleData":"1451828"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1451828"},"op":"LessThenEquals","ruleData":"1451828"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1451829"},"type":"variable","ruleData":"1451829"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1451829"},"op":"Equals","ruleData":"1451829"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451830"},"type":"variable","ruleData":"1451830"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1451830"},"op":"Equals","ruleData":"1451830"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1451831"},"type":"variable","ruleData":"1451831"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1451831"},"op":"Equals","ruleData":"1451831"}],"ruleData":"1039684"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451832"},"type":"variable","ruleData":"1451832"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451832"},"op":"Equals","ruleData":"1451832"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451833"},"type":"variable","ruleData":"1451833"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451833"},"op":"Equals","ruleData":"1451833"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451834"},"type":"variable","ruleData":"1451834"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451834"},"op":"Equals","ruleData":"1451834"}],"ruleData":"1039687"}],"ruleData":"1039686"}],"ruleData":"1039685"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451835"},"type":"variable","ruleData":"1451835"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451835"},"op":"Equals","ruleData":"1451835"}],"ruleData":"1039688"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1451836"},"type":"variable","ruleData":"1451836"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1451836"},"op":"Equals","ruleData":"1451836"}],"ruleData":"1039689"}],"ruleData":1039683}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1451837"},"ruleData":"1451837"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451838"},"ruleData":"1451838"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1451839"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1451840"},"ruleData":"1451840"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1451841"},"ruleData":"1451841"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1452020"},"type":"variable","ruleData":"1452020"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1452020"},"op":"Equals","ruleData":"1452020"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1452021"},"type":"variable","ruleData":"1452021"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1452021"},"op":"Equals","ruleData":"1452021"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1452022"},"type":"variable","ruleData":"1452022"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1452022"},"op":"LessThenEquals","ruleData":"1452022"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1452023"},"type":"variable","ruleData":"1452023"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1452023"},"op":"Equals","ruleData":"1452023"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1452024"},"type":"variable","ruleData":"1452024"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1452024"},"op":"Equals","ruleData":"1452024"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1452025"},"type":"variable","ruleData":"1452025"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1452025"},"op":"Equals","ruleData":"1452025"}],"ruleData":"1039813"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452026"},"type":"variable","ruleData":"1452026"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452026"},"op":"Equals","ruleData":"1452026"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452027"},"type":"variable","ruleData":"1452027"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452027"},"op":"Equals","ruleData":"1452027"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452028"},"type":"variable","ruleData":"1452028"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452028"},"op":"Equals","ruleData":"1452028"}],"ruleData":"1039816"}],"ruleData":"1039815"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452029"},"type":"variable","ruleData":"1452029"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452029"},"op":"Equals","ruleData":"1452029"}],"ruleData":"1039817"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452030"},"type":"variable","ruleData":"1452030"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452030"},"op":"Equals","ruleData":"1452030"}],"ruleData":"1039818"}],"ruleData":"1039814"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452031"},"type":"variable","ruleData":"1452031"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452031"},"op":"Equals","ruleData":"1452031"}],"ruleData":"1039819"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1452032"},"type":"variable","ruleData":"1452032"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1452032"},"op":"Equals","ruleData":"1452032"}],"ruleData":"1039820"}],"ruleData":1039812}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1452033"},"ruleData":"1452033"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1452034"},"ruleData":"1452034"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1452035"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1452036"},"ruleData":"1452036"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1452037"},"ruleData":"1452037"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1454295"},"type":"variable","ruleData":"1454295"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1454295"},"op":"Equals","ruleData":"1454295"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1454296"},"type":"variable","ruleData":"1454296"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1454296"},"op":"Equals","ruleData":"1454296"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1454297"},"type":"variable","ruleData":"1454297"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1454297"},"op":"LessThenEquals","ruleData":"1454297"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1454298"},"type":"variable","ruleData":"1454298"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1454298"},"op":"Equals","ruleData":"1454298"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454299"},"type":"variable","ruleData":"1454299"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1454299"},"op":"Equals","ruleData":"1454299"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454300"},"type":"variable","ruleData":"1454300"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1454300"},"op":"Equals","ruleData":"1454300"}],"ruleData":"1041322"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454301"},"type":"variable","ruleData":"1454301"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454301"},"op":"Equals","ruleData":"1454301"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454302"},"type":"variable","ruleData":"1454302"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454302"},"op":"Equals","ruleData":"1454302"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454303"},"type":"variable","ruleData":"1454303"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454303"},"op":"Equals","ruleData":"1454303"}],"ruleData":"1041325"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454304"},"type":"variable","ruleData":"1454304"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454304"},"op":"Equals","ruleData":"1454304"}],"ruleData":"1041326"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454305"},"type":"variable","ruleData":"1454305"},"value":{"content":"07","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454305"},"op":"Equals","ruleData":"1454305"}],"ruleData":"1041327"}],"ruleData":"1041324"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454306"},"type":"variable","ruleData":"1454306"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454306"},"op":"Equals","ruleData":"1454306"}],"ruleData":"1041328"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454307"},"type":"variable","ruleData":"1454307"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454307"},"op":"Equals","ruleData":"1454307"}],"ruleData":"1041329"}],"ruleData":"1041323"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454308"},"type":"variable","ruleData":"1454308"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454308"},"op":"Equals","ruleData":"1454308"}],"ruleData":"1041330"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454309"},"type":"variable","ruleData":"1454309"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454309"},"op":"Equals","ruleData":"1454309"}],"ruleData":"1041331"}],"ruleData":1041321}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1454310"},"ruleData":"1454310"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454311"},"ruleData":"1454311"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1454312"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1454313"},"ruleData":"1454313"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454314"},"ruleData":"1454314"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1454405"},"type":"variable","ruleData":"1454405"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1454405"},"op":"Equals","ruleData":"1454405"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1454406"},"type":"variable","ruleData":"1454406"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1454406"},"op":"Equals","ruleData":"1454406"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1454407"},"type":"variable","ruleData":"1454407"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1454407"},"op":"LessThenEquals","ruleData":"1454407"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1454408"},"type":"variable","ruleData":"1454408"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1454408"},"op":"Equals","ruleData":"1454408"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454409"},"type":"variable","ruleData":"1454409"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1454409"},"op":"Equals","ruleData":"1454409"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454410"},"type":"variable","ruleData":"1454410"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1454410"},"op":"Equals","ruleData":"1454410"}],"ruleData":"1041386"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454411"},"type":"variable","ruleData":"1454411"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454411"},"op":"Equals","ruleData":"1454411"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454412"},"type":"variable","ruleData":"1454412"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454412"},"op":"Equals","ruleData":"1454412"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454413"},"type":"variable","ruleData":"1454413"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454413"},"op":"Equals","ruleData":"1454413"}],"ruleData":"1041389"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454414"},"type":"variable","ruleData":"1454414"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454414"},"op":"Equals","ruleData":"1454414"}],"ruleData":"1041390"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454415"},"type":"variable","ruleData":"1454415"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454415"},"op":"Equals","ruleData":"1454415"}],"ruleData":"1041391"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454416"},"type":"variable","ruleData":"1454416"},"value":{"content":"07","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454416"},"op":"Equals","ruleData":"1454416"}],"ruleData":"1041392"}],"ruleData":"1041388"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454417"},"type":"variable","ruleData":"1454417"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454417"},"op":"Equals","ruleData":"1454417"}],"ruleData":"1041393"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454418"},"type":"variable","ruleData":"1454418"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454418"},"op":"Equals","ruleData":"1454418"}],"ruleData":"1041394"}],"ruleData":"1041387"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454419"},"type":"variable","ruleData":"1454419"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454419"},"op":"Equals","ruleData":"1454419"}],"ruleData":"1041395"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454420"},"type":"variable","ruleData":"1454420"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454420"},"op":"Equals","ruleData":"1454420"}],"ruleData":"1041396"}],"ruleData":1041385}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1454421"},"ruleData":"1454421"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454422"},"ruleData":"1454422"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1454423"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1454424"},"ruleData":"1454424"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454425"},"ruleData":"1454425"}]}}]}]
//五层:俩并且
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1454520"},"type":"variable","ruleData":"1454520"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1454520"},"op":"Equals","ruleData":"1454520"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1454521"},"type":"variable","ruleData":"1454521"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1454521"},"op":"Equals","ruleData":"1454521"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1454522"},"type":"variable","ruleData":"1454522"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1454522"},"op":"LessThenEquals","ruleData":"1454522"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1454523"},"type":"variable","ruleData":"1454523"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1454523"},"op":"Equals","ruleData":"1454523"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454524"},"type":"variable","ruleData":"1454524"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1454524"},"op":"Equals","ruleData":"1454524"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454525"},"type":"variable","ruleData":"1454525"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1454525"},"op":"Equals","ruleData":"1454525"}],"ruleData":"1041477"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454526"},"type":"variable","ruleData":"1454526"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454526"},"op":"Equals","ruleData":"1454526"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454527"},"type":"variable","ruleData":"1454527"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454527"},"op":"Equals","ruleData":"1454527"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454528"},"type":"variable","ruleData":"1454528"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454528"},"op":"Equals","ruleData":"1454528"}],"ruleData":"1041480"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454529"},"type":"variable","ruleData":"1454529"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454529"},"op":"Equals","ruleData":"1454529"}],"ruleData":"1041481"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454530"},"type":"variable","ruleData":"1454530"},"value":{"content":"09。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454530"},"op":"Equals","ruleData":"1454530"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454531"},"type":"variable","ruleData":"1454531"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454531"},"op":"Equals","ruleData":"1454531"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454532"},"type":"variable","ruleData":"1454532"},"value":{"content":"12","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454532"},"op":"Equals","ruleData":"1454532"}],"ruleData":"1041483"}],"ruleData":"1041482"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454533"},"type":"variable","ruleData":"1454533"},"value":{"content":"07","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454533"},"op":"Equals","ruleData":"1454533"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454534"},"type":"variable","ruleData":"1454534"},"value":{"content":"10","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454534"},"op":"Equals","ruleData":"1454534"}],"ruleData":"1041485"}],"ruleData":"1041484"}],"ruleData":"1041479"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454535"},"type":"variable","ruleData":"1454535"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454535"},"op":"Equals","ruleData":"1454535"}],"ruleData":"1041486"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454536"},"type":"variable","ruleData":"1454536"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454536"},"op":"Equals","ruleData":"1454536"}],"ruleData":"1041487"}],"ruleData":"1041478"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454537"},"type":"variable","ruleData":"1454537"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454537"},"op":"Equals","ruleData":"1454537"}],"ruleData":"1041488"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454538"},"type":"variable","ruleData":"1454538"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454538"},"op":"Equals","ruleData":"1454538"}],"ruleData":"1041489"}],"ruleData":1041476}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1454539"},"ruleData":"1454539"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454540"},"ruleData":"1454540"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1454541"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1454542"},"ruleData":"1454542"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454543"},"ruleData":"1454543"}]}}]}]
//五层:一并且两内容
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1454918"},"type":"variable","ruleData":"1454918"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1454918"},"op":"Equals","ruleData":"1454918"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1454919"},"type":"variable","ruleData":"1454919"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1454919"},"op":"Equals","ruleData":"1454919"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1454920"},"type":"variable","ruleData":"1454920"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1454920"},"op":"LessThenEquals","ruleData":"1454920"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1454921"},"type":"variable","ruleData":"1454921"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1454921"},"op":"Equals","ruleData":"1454921"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454922"},"type":"variable","ruleData":"1454922"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1454922"},"op":"Equals","ruleData":"1454922"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1454923"},"type":"variable","ruleData":"1454923"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1454923"},"op":"Equals","ruleData":"1454923"}],"ruleData":"1041753"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454924"},"type":"variable","ruleData":"1454924"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454924"},"op":"Equals","ruleData":"1454924"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454925"},"type":"variable","ruleData":"1454925"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454925"},"op":"Equals","ruleData":"1454925"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454926"},"type":"variable","ruleData":"1454926"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454926"},"op":"Equals","ruleData":"1454926"}],"ruleData":"1041756"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454927"},"type":"variable","ruleData":"1454927"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454927"},"op":"Equals","ruleData":"1454927"}],"ruleData":"1041757"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454928"},"type":"variable","ruleData":"1454928"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454928"},"op":"Equals","ruleData":"1454928"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454929"},"type":"variable","ruleData":"1454929"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454929"},"op":"Equals","ruleData":"1454929"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454930"},"type":"variable","ruleData":"1454930"},"value":{"content":"12","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454930"},"op":"Equals","ruleData":"1454930"}],"ruleData":"1041759"}],"ruleData":"1041758"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454931"},"type":"variable","ruleData":"1454931"},"value":{"content":"07。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454931"},"op":"Equals","ruleData":"1454931"}],"ruleData":"1041760"}],"ruleData":"1041755"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454932"},"type":"variable","ruleData":"1454932"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454932"},"op":"Equals","ruleData":"1454932"}],"ruleData":"1041761"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454933"},"type":"variable","ruleData":"1454933"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454933"},"op":"Equals","ruleData":"1454933"}],"ruleData":"1041762"}],"ruleData":"1041754"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454934"},"type":"variable","ruleData":"1454934"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454934"},"op":"Equals","ruleData":"1454934"}],"ruleData":"1041763"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1454935"},"type":"variable","ruleData":"1454935"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1454935"},"op":"Equals","ruleData":"1454935"}],"ruleData":"1041764"}],"ruleData":1041752}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1454936"},"ruleData":"1454936"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454937"},"ruleData":"1454937"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1454938"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1454939"},"ruleData":"1454939"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1454940"},"ruleData":"1454940"}]}}]}]
//五层：一并且两内容，一或者1内容
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1456468"},"type":"variable","ruleData":"1456468"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1456468"},"op":"Equals","ruleData":"1456468"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1456469"},"type":"variable","ruleData":"1456469"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1456469"},"op":"Equals","ruleData":"1456469"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1456470"},"type":"variable","ruleData":"1456470"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1456470"},"op":"LessThenEquals","ruleData":"1456470"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1456471"},"type":"variable","ruleData":"1456471"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1456471"},"op":"Equals","ruleData":"1456471"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1456472"},"type":"variable","ruleData":"1456472"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1456472"},"op":"Equals","ruleData":"1456472"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1456473"},"type":"variable","ruleData":"1456473"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1456473"},"op":"Equals","ruleData":"1456473"}],"ruleData":"1042862"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456474"},"type":"variable","ruleData":"1456474"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456474"},"op":"Equals","ruleData":"1456474"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456475"},"type":"variable","ruleData":"1456475"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456475"},"op":"Equals","ruleData":"1456475"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456476"},"type":"variable","ruleData":"1456476"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456476"},"op":"Equals","ruleData":"1456476"}],"ruleData":"1042865"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456477"},"type":"variable","ruleData":"1456477"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456477"},"op":"Equals","ruleData":"1456477"}],"ruleData":"1042866"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456478"},"type":"variable","ruleData":"1456478"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456478"},"op":"Equals","ruleData":"1456478"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456479"},"type":"variable","ruleData":"1456479"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456479"},"op":"Equals","ruleData":"1456479"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456480"},"type":"variable","ruleData":"1456480"},"value":{"content":"12。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456480"},"op":"Equals","ruleData":"1456480"}],"ruleData":"1042868"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456481"},"type":"variable","ruleData":"1456481"},"value":{"content":"13。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456481"},"op":"Equals","ruleData":"1456481"}],"ruleData":"1042869"}],"ruleData":"1042867"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456482"},"type":"variable","ruleData":"1456482"},"value":{"content":"07。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456482"},"op":"Equals","ruleData":"1456482"}],"ruleData":"1042870"}],"ruleData":"1042864"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456483"},"type":"variable","ruleData":"1456483"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456483"},"op":"Equals","ruleData":"1456483"}],"ruleData":"1042871"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456484"},"type":"variable","ruleData":"1456484"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456484"},"op":"Equals","ruleData":"1456484"}],"ruleData":"1042872"}],"ruleData":"1042863"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456485"},"type":"variable","ruleData":"1456485"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456485"},"op":"Equals","ruleData":"1456485"}],"ruleData":"1042873"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456486"},"type":"variable","ruleData":"1456486"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456486"},"op":"Equals","ruleData":"1456486"}],"ruleData":"1042874"}],"ruleData":1042861}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1456487"},"ruleData":"1456487"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1456488"},"ruleData":"1456488"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1456489"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1456490"},"ruleData":"1456490"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1456491"},"ruleData":"1456491"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1456586"},"type":"variable","ruleData":"1456586"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1456586"},"op":"Equals","ruleData":"1456586"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1456587"},"type":"variable","ruleData":"1456587"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1456587"},"op":"Equals","ruleData":"1456587"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1456588"},"type":"variable","ruleData":"1456588"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1456588"},"op":"LessThenEquals","ruleData":"1456588"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1456589"},"type":"variable","ruleData":"1456589"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1456589"},"op":"Equals","ruleData":"1456589"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1456590"},"type":"variable","ruleData":"1456590"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1456590"},"op":"Equals","ruleData":"1456590"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1456591"},"type":"variable","ruleData":"1456591"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1456591"},"op":"Equals","ruleData":"1456591"}],"ruleData":"1042934"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456592"},"type":"variable","ruleData":"1456592"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456592"},"op":"Equals","ruleData":"1456592"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456593"},"type":"variable","ruleData":"1456593"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456593"},"op":"Equals","ruleData":"1456593"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456594"},"type":"variable","ruleData":"1456594"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456594"},"op":"Equals","ruleData":"1456594"}],"ruleData":"1042937"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456595"},"type":"variable","ruleData":"1456595"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456595"},"op":"Equals","ruleData":"1456595"}],"ruleData":"1042938"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456596"},"type":"variable","ruleData":"1456596"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456596"},"op":"Equals","ruleData":"1456596"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456597"},"type":"variable","ruleData":"1456597"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456597"},"op":"Equals","ruleData":"1456597"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456598"},"type":"variable","ruleData":"1456598"},"value":{"content":"12。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456598"},"op":"Equals","ruleData":"1456598"}],"ruleData":"1042940"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456599"},"type":"variable","ruleData":"1456599"},"value":{"content":"13。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456599"},"op":"Equals","ruleData":"1456599"}],"ruleData":"1042941"}],"ruleData":"1042939"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456600"},"type":"variable","ruleData":"1456600"},"value":{"content":"07。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456600"},"op":"Equals","ruleData":"1456600"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456601"},"type":"variable","ruleData":"1456601"},"value":{"content":"14。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456601"},"op":"Equals","ruleData":"1456601"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456602"},"type":"variable","ruleData":"1456602"},"value":{"content":"15","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456602"},"op":"Equals","ruleData":"1456602"}],"ruleData":"1042943"}],"ruleData":"1042942"}],"ruleData":"1042936"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456603"},"type":"variable","ruleData":"1456603"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456603"},"op":"Equals","ruleData":"1456603"}],"ruleData":"1042944"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456604"},"type":"variable","ruleData":"1456604"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456604"},"op":"Equals","ruleData":"1456604"}],"ruleData":"1042945"}],"ruleData":"1042935"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456605"},"type":"variable","ruleData":"1456605"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456605"},"op":"Equals","ruleData":"1456605"}],"ruleData":"1042946"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1456606"},"type":"variable","ruleData":"1456606"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1456606"},"op":"Equals","ruleData":"1456606"}],"ruleData":"1042947"}],"ruleData":1042933}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1456607"},"ruleData":"1456607"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1456608"},"ruleData":"1456608"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1456609"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1456610"},"ruleData":"1456610"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1456611"},"ruleData":"1456611"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1458910"},"type":"variable","ruleData":"1458910"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1458910"},"op":"Equals","ruleData":"1458910"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1458911"},"type":"variable","ruleData":"1458911"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1458911"},"op":"Equals","ruleData":"1458911"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1458912"},"type":"variable","ruleData":"1458912"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1458912"},"op":"LessThenEquals","ruleData":"1458912"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1458913"},"type":"variable","ruleData":"1458913"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1458913"},"op":"Equals","ruleData":"1458913"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1458914"},"type":"variable","ruleData":"1458914"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1458914"},"op":"Equals","ruleData":"1458914"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1458915"},"type":"variable","ruleData":"1458915"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1458915"},"op":"Equals","ruleData":"1458915"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458916"},"type":"variable","ruleData":"1458916"},"value":{"content":"16","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458916"},"op":"Equals","ruleData":"1458916"}],"ruleData":"1044644"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458917"},"type":"variable","ruleData":"1458917"},"value":{"content":"17","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458917"},"op":"Equals","ruleData":"1458917"}],"ruleData":"1044645"}],"ruleData":"1044643"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458918"},"type":"variable","ruleData":"1458918"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458918"},"op":"Equals","ruleData":"1458918"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458919"},"type":"variable","ruleData":"1458919"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458919"},"op":"Equals","ruleData":"1458919"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458920"},"type":"variable","ruleData":"1458920"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458920"},"op":"Equals","ruleData":"1458920"}],"ruleData":"1044648"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458921"},"type":"variable","ruleData":"1458921"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458921"},"op":"Equals","ruleData":"1458921"}],"ruleData":"1044649"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458922"},"type":"variable","ruleData":"1458922"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458922"},"op":"Equals","ruleData":"1458922"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458923"},"type":"variable","ruleData":"1458923"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458923"},"op":"Equals","ruleData":"1458923"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458924"},"type":"variable","ruleData":"1458924"},"value":{"content":"12。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458924"},"op":"Equals","ruleData":"1458924"}],"ruleData":"1044651"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458925"},"type":"variable","ruleData":"1458925"},"value":{"content":"13。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458925"},"op":"Equals","ruleData":"1458925"}],"ruleData":"1044652"}],"ruleData":"1044650"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458926"},"type":"variable","ruleData":"1458926"},"value":{"content":"07。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458926"},"op":"Equals","ruleData":"1458926"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458927"},"type":"variable","ruleData":"1458927"},"value":{"content":"14。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458927"},"op":"Equals","ruleData":"1458927"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458928"},"type":"variable","ruleData":"1458928"},"value":{"content":"15。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458928"},"op":"Equals","ruleData":"1458928"}],"ruleData":"1044654"}],"ruleData":"1044653"}],"ruleData":"1044647"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458929"},"type":"variable","ruleData":"1458929"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458929"},"op":"Equals","ruleData":"1458929"}],"ruleData":"1044655"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458930"},"type":"variable","ruleData":"1458930"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458930"},"op":"Equals","ruleData":"1458930"}],"ruleData":"1044656"}],"ruleData":"1044646"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458931"},"type":"variable","ruleData":"1458931"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458931"},"op":"Equals","ruleData":"1458931"}],"ruleData":"1044657"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1458932"},"type":"variable","ruleData":"1458932"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1458932"},"op":"Equals","ruleData":"1458932"}],"ruleData":"1044658"}],"ruleData":1044642}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1458933"},"ruleData":"1458933"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1458934"},"ruleData":"1458934"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1458935"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1458936"},"ruleData":"1458936"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1458937"},"ruleData":"1458937"}]}}]}]
//五层:一分支三并且无内容
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1463265"},"type":"variable","ruleData":"1463265"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1463265"},"op":"Equals","ruleData":"1463265"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1463266"},"type":"variable","ruleData":"1463266"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1463266"},"op":"Equals","ruleData":"1463266"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1463267"},"type":"variable","ruleData":"1463267"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1463267"},"op":"LessThenEquals","ruleData":"1463267"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463268"},"type":"variable","ruleData":"1463268"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1463268"},"op":"Equals","ruleData":"1463268"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463269"},"type":"variable","ruleData":"1463269"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463269"},"op":"GreaterThen","ruleData":"1463269"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463270"},"type":"variable","ruleData":"1463270"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1463270"},"op":"Equals","ruleData":"1463270"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463271"},"type":"variable","ruleData":"1463271"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1463271"},"op":"Equals","ruleData":"1463271"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463272"},"type":"variable","ruleData":"1463272"},"value":{"content":"16","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463272"},"op":"Equals","ruleData":"1463272"}],"ruleData":"1047654"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463273"},"type":"variable","ruleData":"1463273"},"value":{"content":"17","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463273"},"op":"Equals","ruleData":"1463273"}],"ruleData":"1047655"}],"ruleData":"1047653"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463274"},"type":"variable","ruleData":"1463274"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463274"},"op":"Equals","ruleData":"1463274"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463275"},"type":"variable","ruleData":"1463275"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463275"},"op":"Equals","ruleData":"1463275"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463276"},"type":"variable","ruleData":"1463276"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463276"},"op":"Equals","ruleData":"1463276"}],"ruleData":"1047658"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463277"},"type":"variable","ruleData":"1463277"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463277"},"op":"Equals","ruleData":"1463277"}],"ruleData":"1047659"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463278"},"type":"variable","ruleData":"1463278"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463278"},"op":"Equals","ruleData":"1463278"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463279"},"type":"variable","ruleData":"1463279"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463279"},"op":"Equals","ruleData":"1463279"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463280"},"type":"variable","ruleData":"1463280"},"value":{"content":"12。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463280"},"op":"Equals","ruleData":"1463280"}],"ruleData":"1047661"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463281"},"type":"variable","ruleData":"1463281"},"value":{"content":"13。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463281"},"op":"Equals","ruleData":"1463281"}],"ruleData":"1047662"}],"ruleData":"1047660"},{"junctionType":"or","criterions":[{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463282"},"type":"variable","ruleData":"1463282"},"value":{"content":"14。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463282"},"op":"Equals","ruleData":"1463282"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463283"},"type":"variable","ruleData":"1463283"},"value":{"content":"15。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463283"},"op":"Equals","ruleData":"1463283"}],"ruleData":"1047664"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463284"},"type":"variable","ruleData":"1463284"},"value":{"content":"16。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463284"},"op":"GreaterThen","ruleData":"1463284"}],"ruleData":"1047665"}],"ruleData":"1047663"}],"ruleData":"1047657"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463285"},"type":"variable","ruleData":"1463285"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463285"},"op":"Equals","ruleData":"1463285"}],"ruleData":"1047666"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463286"},"type":"variable","ruleData":"1463286"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463286"},"op":"Equals","ruleData":"1463286"}],"ruleData":"1047667"}],"ruleData":"1047656"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463287"},"type":"variable","ruleData":"1463287"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463287"},"op":"Equals","ruleData":"1463287"}],"ruleData":"1047668"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463288"},"type":"variable","ruleData":"1463288"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463288"},"op":"Equals","ruleData":"1463288"}],"ruleData":"1047669"}],"ruleData":1047652}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1463289"},"ruleData":"1463289"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1463290"},"ruleData":"1463290"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1463291"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1463292"},"ruleData":"1463292"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1463293"},"ruleData":"1463293"}]}}]}]
//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1463320"},"type":"variable","ruleData":"1463320"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1463320"},"op":"Equals","ruleData":"1463320"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1463321"},"type":"variable","ruleData":"1463321"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1463321"},"op":"Equals","ruleData":"1463321"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1463322"},"type":"variable","ruleData":"1463322"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1463322"},"op":"LessThenEquals","ruleData":"1463322"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"用药频率","variableName":"45","ruleData":"1463323"},"type":"variable","ruleData":"1463323"},"value":{"constantCategory":"4105","constantName":"4105","constantLabel":"q12h","valueType":"Constant","ruleData":"1463323"},"op":"Equals","ruleData":"1463323"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463324"},"type":"variable","ruleData":"1463324"},"value":{"content":"1","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463324"},"op":"GreaterThen","ruleData":"1463324"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463325"},"type":"variable","ruleData":"1463325"},"value":{"constantCategory":"3922","constantName":"3922","constantLabel":"肌内注射","valueType":"Constant","ruleData":"1463325"},"op":"Equals","ruleData":"1463325"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"给药途径","variableName":"46","ruleData":"1463326"},"type":"variable","ruleData":"1463326"},"value":{"constantCategory":"3927","constantName":"3927","constantLabel":"静脉滴注","valueType":"Constant","ruleData":"1463326"},"op":"Equals","ruleData":"1463326"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463327"},"type":"variable","ruleData":"1463327"},"value":{"content":"16","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463327"},"op":"Equals","ruleData":"1463327"}],"ruleData":"1047699"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463328"},"type":"variable","ruleData":"1463328"},"value":{"content":"17","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463328"},"op":"Equals","ruleData":"1463328"}],"ruleData":"1047700"}],"ruleData":"1047698"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463329"},"type":"variable","ruleData":"1463329"},"value":{"content":"01","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463329"},"op":"Equals","ruleData":"1463329"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463330"},"type":"variable","ruleData":"1463330"},"value":{"content":"02","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463330"},"op":"Equals","ruleData":"1463330"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463331"},"type":"variable","ruleData":"1463331"},"value":{"content":"04","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463331"},"op":"Equals","ruleData":"1463331"}],"ruleData":"1047703"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463332"},"type":"variable","ruleData":"1463332"},"value":{"content":"08。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463332"},"op":"Equals","ruleData":"1463332"}],"ruleData":"1047704"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463333"},"type":"variable","ruleData":"1463333"},"value":{"content":"09","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463333"},"op":"Equals","ruleData":"1463333"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463334"},"type":"variable","ruleData":"1463334"},"value":{"content":"11","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463334"},"op":"Equals","ruleData":"1463334"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463335"},"type":"variable","ruleData":"1463335"},"value":{"content":"12。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463335"},"op":"Equals","ruleData":"1463335"}],"ruleData":"1047706"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463336"},"type":"variable","ruleData":"1463336"},"value":{"content":"13。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463336"},"op":"Equals","ruleData":"1463336"}],"ruleData":"1047707"}],"ruleData":"1047705"},{"junctionType":"or","criterions":[{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463337"},"type":"variable","ruleData":"1463337"},"value":{"content":"14。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463337"},"op":"Equals","ruleData":"1463337"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463338"},"type":"variable","ruleData":"1463338"},"value":{"content":"15。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463338"},"op":"Equals","ruleData":"1463338"}],"ruleData":"1047709"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463339"},"type":"variable","ruleData":"1463339"},"value":{"content":"16。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463339"},"op":"GreaterThen","ruleData":"1463339"}],"ruleData":"1047710"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463340"},"type":"variable","ruleData":"1463340"},"value":{"content":"17","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463340"},"op":"GreaterThen","ruleData":"1463340"}],"ruleData":"1047711"}],"ruleData":"1047708"}],"ruleData":"1047702"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463341"},"type":"variable","ruleData":"1463341"},"value":{"content":"06","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463341"},"op":"Equals","ruleData":"1463341"}],"ruleData":"1047712"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463342"},"type":"variable","ruleData":"1463342"},"value":{"content":"05","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463342"},"op":"Equals","ruleData":"1463342"}],"ruleData":"1047713"}],"ruleData":"1047701"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463343"},"type":"variable","ruleData":"1463343"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463343"},"op":"Equals","ruleData":"1463343"}],"ruleData":"1047714"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1463344"},"type":"variable","ruleData":"1463344"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1463344"},"op":"Equals","ruleData":"1463344"}],"ruleData":"1047715"}],"ruleData":1047697}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1463345"},"ruleData":"1463345"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1463346"},"ruleData":"1463346"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1463347"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1463348"},"ruleData":"1463348"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1463349"},"ruleData":"1463349"}]}}]}]
var selectBox = [{"value":"and","text":'并且'}, {"value":"or","text":'或者'}, {"value":"union","text":'联合'}, {"value":"additem","text":'添加条件'}, {"value":"addunionitem","text":'添加联合条件'}, {"value":"del","text":'删除'}];
/*
readme:如果、那么、否则三部分;
如果（svg[path],logic,con）
*/
var count=1; //最后可直接删除
var attrsels = "";   //动态面板选择对象
function initPageDefault()
{
	/*
	var sum=(function(){    
	
		'use strict'    
		return  function fun(num){        
			if(num<=1){ 
		   return 1;        
		 }else{            
		   return num+fun(num-1);        
		 }    
	 } 
	})()
 console.log(sum(5));//15
	var sumAnother=sum; console.log(sumAnother(5));//15
	sum=null; console.log(sumAnother(5));//15
	*/
	
	var path=(function(){ //st
	  'use strict'
	  return  function fun(x,y,Object){ 
	      var xx=x-1;
	      var ySt="ySt"+x;
	      var xSt="xSt"+x;
	      var i="i"+x;
	      var Objxx="Obj"+xx;
	      var Objxx=Object;
	      var Obj="Obj"+x;
							var ySt=y;
							var xSt=x;
							PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Objxx.junctionType); //逻辑
							var Obj=Objxx.criterions;
							for (i=0;i<Obj.length; i++) {//--
								   if(i!=0)y=y+1;
											html = html +displayPathOne(xSt, ySt, y);
											if(Obj[i].op==undefined){
												 y=fun(x+1,y,Obj[i]);			 
			        }else{
				        	PathConHtml=PathConHtml+displayPathCon(x,y,Obj[i],ySt); //内容 //2020-11-09 add ySt
				       }
		      }
		     return y;
	  } 
	  
	})()
	var pathLine=path; //ed
	
	//alert(_json[0].rules[0].lhs.criterion)
	//alert(_json[0].rules[0].lhs.criterion.junctionType)
	var junctionType=_json[0].rules[0].lhs.criterion.junctionType;
	var Obj1=_json[0].rules[0].lhs.criterion.criterions;
	var x=1,y=1,height=100,html="",PathSpanHtml="",PathConHtml="";
	html = html + '<svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative; left: -0.997159px; top: -0.0880647px;">';
	html = html + '<desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Raphaël 2.2.0</desc>';
	html = html + '<defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></defs>';
	PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,junctionType); //第一个逻辑
	for (i=0; i<Obj1.length; i++) {
		 if(i!=0)y=y+1;
		 html = html +displayPathOne(1, 1, y);
			if(Obj1[i].op==undefined){///
			  y=pathLine(x+1,y,Obj1[i]);
			  /*x=2;
				 var ySt2=y;
				 var xSt2=x;
				 PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj1[i].junctionType); //逻辑
				 var Obj2=Obj1[i].criterions;
				 for (i2=0; i2<Obj2.length; i2++) {//--
				 //alert(2+"**"+j)
				   if(i2!=0)y=y+1;
							html = html +displayPathOne(xSt2, ySt2, y);
							if(Obj2[i2].op==undefined){///
							  x=3;
								 var ySt3=y;
								 var xSt3=x;
								 PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj2[i2].junctionType); //逻辑
								 var Obj3=Obj2[i2].criterions;
								 for (i3=0;i3<Obj3.length; i3++) {//--
								 //alert(3+"**"+k)
								   if(i3!=0)y=y+1;
											html = html +displayPathOne(xSt3, ySt3, y);
											if(Obj3[i3].op==undefined){///
											  x=4;
								     var ySt4=y;
								     var xSt4=x;
								     PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj3[i3].junctionType); //逻辑
								     var Obj4=Obj3[i3].criterions;
								     for (i4=0; i4<Obj4.length; i4++) {//--
													 //alert(4+"**"+l)
													   if(i4!=0)y=y+1;
																html = html +displayPathOne(xSt4, ySt4, y);
																if(Obj4[i4].op==undefined){}
								     }
												
											}
								 }//--
				   }
				 }//-- */
	   }else{
		    PathConHtml=PathConHtml+displayPathCon(1,y,Obj1[i],1); //第一个内容 //2020-11-09 add ,1
		  }
			
	}	
	//html = html + '<path fill="none" stroke="#777777" d="M45,16C45,16,45,16,80,16" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path>';
	//html=html+displayPathSpan(1,1,junctionType); //第一个逻辑
	html=html+"<div id='PathLog'>"+PathSpanHtml+"</div>"; //逻辑
	html=html+"<div id='PathCon'>"+PathConHtml+"</div>"; //内容
	/*//Part1st
	var lhs=_json[0].rules[0].lhs.criterion.criterions;
	var htmlOne="";
	//for (i=0; i<lhs.length; i++) {
	  htmlOne=htmlOne+"<div style='position: absolute; left: 80px; top: 8px;'>"
			htmlOne=htmlOne+"	<span style='font-size:12px'>"
			htmlOne=htmlOne+"  <span class='line-darkcyan'>西医疾病</span>"
			htmlOne=htmlOne+"  <span class='line-red'>等于</span>"
			htmlOne=htmlOne+"		<span class='line-blue'>哮喘</span>"
			htmlOne=htmlOne+"	</span>"
			htmlOne=htmlOne+"	<i class='glyphicon glyphicon-trash line-i'></i>"
			htmlOne=htmlOne+"</div>"
	//}
	html=html+htmlOne;
	//Part1ed*/


	height=y*30;
	html = '<div style="height:'+height+'px; position: relative;">'+html;
	html = html + '</svg>';
	html = html + '</div>';
	
	$("#line").html(html);

	//Part2st
	var rhs=_json[0].rules[0].rhs.actions;
	
	var htmlTwo="<span><strong class='font-12'>那么</strong><span class='rule-add-action font-12' onclick='addelseItm(1)'>添加动作</span></span>"
	htmlTwo=htmlTwo+"<div id='then' style='padding: 5px;' class='ui-sortable'>"
	for (i=0; i<rhs.length; i++) {
		 htmlTwo=htmlTwo+"<div class='rule-action' id='"+rhs[i].ruleData+"' data='"+rhs[i].variableCategoryId+"^"+rhs[i].variableName+"'>"
			//htmlTwo=htmlTwo+"<i class='glyphicon glyphicon-remove rule-delete-action'></i>"
			htmlTwo=htmlTwo+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
			htmlTwo=htmlTwo+"	<span class='line-green'>变量赋值:</span>"
			htmlTwo=htmlTwo+" <span class='blank'>.</span>"
			htmlTwo=htmlTwo+" <span class='line-darkcyan-zero'>"+rhs[i].variableCategory+"的"+rhs[i].variableLabel+"</span>"
			htmlTwo=htmlTwo+" <span style='color: red;'>=</span>"
			htmlTwo=htmlTwo+" <span class='blank'>.</span>"
			if(rhs[i].value.valueType=="Constant"){
			  htmlTwo=htmlTwo+" <span class='line-blue' id='"+rhs[i].value.constantName+"'>"+rhs[i].value.constantLabel+"</span>"
			}else{
				 htmlTwo=htmlTwo+" <span class='line-brown'>"+rhs[i].value.content+"</span>"
			}
			htmlTwo=htmlTwo+" <span class='blank'>.</span>"
			//htmlTwo=htmlTwo+"<span class='icon icon-cancel'>&nbsp;</span>" //放前边更合理
			htmlTwo=htmlTwo+"</div>";
	}
	htmlTwo=htmlTwo+"</div>"			  
	$("#line").append(htmlTwo);
	//Part3st
	var other=_json[0].rules[0].other.actions;
	
 var htmlThr="<div style=margin-top: 5px;>"
	htmlThr=htmlThr+" <span><strong class='font-12'>否则</strong><span class='rule-add-action font-12' onclick='addelseItm(2)'>添加动作</span></span>"
	htmlThr=htmlThr+" <div id='else' style='padding: 5px' class='ui-sortable'>"	    
	for (i=0; i<other.length; i++) {
		  htmlThr=htmlThr+"  <div class='rule-action' id='"+other[i].ruleData+"' data='"+other[i].variableCategoryId+"^"+other[i].variableName+"'>"
				//htmlThr=htmlThr+"  <i class='glyphicon glyphicon-remove rule-delete-action'></i>"
				htmlThr=htmlThr+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
				htmlThr=htmlThr+"  <span class='line-green'>变量赋值:</span>"
				htmlThr=htmlThr+"  <span class='blank'>.</span>"
				htmlThr=htmlThr+"  <span class='line-darkcyan-zero'>"+other[i].variableCategory+"的"+other[i].variableLabel+"</span>"
				htmlThr=htmlThr+"  <span style='color: red;'>=</span>"
				htmlThr=htmlThr+"  <span class='blank'>.</span>"
				if(other[i].value.valueType=="Constant"){
				  htmlThr=htmlThr+" <span class='line-blue id='"+other[i].value.constantName+"'>"+other[i].value.constantLabel+"</span>"
				}else{
					 htmlThr=htmlThr+" <span class='line-brown'>"+other[i].value.content+"</span>"
				}
				//htmlThr=htmlThr+"<span class='line-blue'>"+other[i].value.constantLabel+"</span>"
			 htmlThr=htmlThr+"<span class='blank'>.</span>"
			 //htmlThr=htmlThr+"<span class='icon icon-cancel'>&nbsp;</span>" //放前边更合理
				htmlThr=htmlThr+"  </div>"
	}
	htmlThr=htmlThr+" </div>"
 htmlThr=htmlThr+"</div>"
	$("#line").append(htmlThr);

 //displayPathAppend(1, 1, 7);//追加一条线
 //displayPathAppend(2, 2, 5);//追加一条线
 //displayPathConAppend(1,1,1);//追加一条内容
 //displayPathLogicAppend(1,2);//追加一个逻辑
 
 initCombobox();
 //displayCombobox("selBox11","or");
 $("body").on('dblclick',function(e){
 	AllUlPanel();
	});

}
///添加then/else
function addelseItm(other)
{
	var otherId = other==1?'then':'else';

	var html = ""
			html = html +"<div class='rule-action' id='' data=''>"
			html = html +"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
			html = html +"<span class='line-green'>变量赋值:</span>"
			html = html +"<span class='line-darkcyan' data_id='' onclick='chooseVar(this)'>请选择变量1</span>"
			html = html +"<span style='color: red;'>=</span>"
			html = html +"<span class='blank' onclick='chooseType(this)'>.</span>"
			html = html +"<span></span>"
			html = html +"</div>";
	$("#"+otherId).append(html);
}
//画单线
function displayPathOne(xLev, ySt, yEd)
{	
		var stX=(xLev-1)*75+45;
	 var stY=(ySt-1)*30+16; 
	 var edX=stX+35;
	 var site=(yEd-ySt)*30+stY;
	 var d="M"+stX+","+stY+"C"+stX+","+site+","+stX+","+site+","+edX+","+site;
	 var rtn=" <path id='"+xLev+"P"+yEd+"' data='"+xLev+"P"+ySt+"P"+yEd+"' fill='none' stroke='#777777' d='"+d+"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>"
  return rtn;
}

//画单线-append
function displayPathAppend(xLev, ySt, yEd,delFlag)
{	
		var stX=(xLev-1)*75+45;
	 var stY=(ySt-1)*30+16; 
	 var edX=stX+35;
	 var site=(yEd-ySt)*30+stY;
	 var d="M"+stX+","+stY+"C"+stX+","+site+","+stX+","+site+","+edX+","+site;
	 var rtn=" <path id='"+xLev+"P"+yEd+"' data='"+xLev+"P"+ySt+"P"+yEd+"' fill='none' stroke='#777777' d='"+d+"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>";
	 var rtn=$("#line>div>svg").html()+rtn;
	 $($("#line>div>svg")).html(rtn);
  //$($("#line>div>svg")).after(rtn);
  if(ySt!=yEd){
  var height=$("#line>div:first").height()+30;
  if(yEd*30>height){height=yEd*30;}
  if(delFlag==1){height=$("#line>div:first").height();} //2020-11-09
  $($("#line>div:first")).height(height);
  }
}

//逻辑关系位置
function displayPathSpan(xLev, yLev, type)
{
	 /*switch (type) {
    case "and":
        type = "并且";
        break; 
    case "or":
        type = "或者";
        break; 
    default: 
    } */

	 var left=(xLev-1)*75+5;
	 var top=(yLev-1)*30+5;
	 var rtn= "<span class='PathLog' style='position: absolute; left: "+left+"px; top: "+top+"px;'>";
	 //rtn=rtn+" <input id='"+xLev+"*"+yLev+"' class='hisui-combobox' style='width:65px;'/></span>";
	 rtn=rtn+" <input id='"+xLev+"Box"+yLev+"' data='"+type+"' class='hisui-combobox' style='width:65px;'/></span>"; //2020-11-20 add data

	 //var id="'#"+xLev+"*"+yLev+"'";
	 var id=xLev+"Box"+yLev;
	 //alert(id);
	 //displayCombobox(id,type);
	 setTimeout(function(){ 
	 		 displayCombobox(id,type);
	 }, 0.01);
	 return rtn;
}

//内容位置
function displayPathCon(xLev, yLev, con,yLevSt) //2020-11-09 add ,yLevSt
{
	  //alert(xLev+"**"+yLev)
	  var op=con.op;
	  var opCode=op;//20201126
	  switch (con.op) {
		  case "GreaterThen":
        op = "大于";
        break; 
		  case "GreaterThenEquals":
        op = "大于或等于";
        break;
    case "Equals":
        op = "等于";
        break;  
    case "NotEquals":
        op = "不等于";
        break;
    case "Between":
        op = "在";
        break;
    case "In":
        op = "在集合";
        break;
    case "LessThen":
        op = "小于";
        break;
    case "LessThenEquals":
        op = "小于或等于";
        break; 
    default: 
   } 
		 var left=xLev*75+5;
	  var top=(yLev-1)*30+10;
		 var htmlOne="<div data='"+xLev+"P"+yLev+"' id='"+xLev+"P"+yLevSt+"T"+yLev+"' style='position: absolute; left: "+left+"px; top: "+top+"px;'>"
			htmlOne=htmlOne+"	<span style='font-size:12px'>"
			var Label=con.left.leftPart.variableLabel;
			if(Label!="")Label="的"+Label;
			htmlOne=htmlOne+"  <span class='line-darkcyan' onclick='chooseVar(this)'>"+con.left.leftPart.variableCategory+Label+"</span>"
			htmlOne=htmlOne+"  <span class='line-red' onclick='chooseOpera(this)' data='"+opCode+"'>"+op+"</span>"
			htmlOne=htmlOne+"  <span class='blank' onclick='chooseType(this)'>&nbsp;</span>" //2020-11-13
			htmlOne=htmlOne+"  <span>" //2020-11-13
			var conValue="";//11-16
			if(con.value.valueType=="Constant"){
					htmlOne=htmlOne+"		<span class='line-blue'>"+con.value.constantLabel+"</span>"
			}else{
				 if(((con.op=="Between")||(con.op=="In")&&(con.value.contentLimit!=""))){ //Between和集合的limit不为空时:有括号，有区间
				   conValue="("+con.value.content+"-"+con.value.contentLimit+")";//11-16
					  htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>("+con.value.content+"-"+con.value.contentLimit+")</span>"
					  htmlOne=htmlOne+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
 						htmlOne=htmlOne+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
					}else{
						 conValue=con.value.content;//11-16
						 htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>"+con.value.content+"</span>"
						 htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
 					}
					//htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
			  htmlOne=htmlOne+"		<span class='line-blue' onclick='chooseUnit(this)'>"+con.value.contentUomDesc+"</span>"
			}
   htmlOne=htmlOne+"  </span><span>" //2020-11-16 内容一个span;之间、之中一个span;
			if(con.op=="Between")htmlOne=htmlOne+"		<span class='line-red'><strong>之间</strong></span>"
   if(con.op=="In")htmlOne=htmlOne+"		<span class='line-red'><strong>之中</strong></span>"
   htmlOne=htmlOne+" </span>" //2020-11-13 
   
			htmlOne=htmlOne+"	</span>"
			htmlOne=htmlOne+"	<span class='icon icon-cancel' onclick='deleteCon(this)'>&nbsp;</span>"
			htmlOne=htmlOne+"</div>"
			return htmlOne;
}

//画内容-append
function displayPathConAppend(xLev, yLevSt, yLev)
{
		var left=xLev*75+5;
	 var top=(yLev-1)*30+10;
	 var htmlOne="<div data='"+xLev+"P"+yLev+"' id='"+xLev+"P"+yLevSt+"T"+yLev+"' style='position: absolute; left: "+left+"px; top: "+top+"px;'>"
		htmlOne=htmlOne+"	<span style='font-size:12px'>"
		htmlOne=htmlOne+"  <span class='line-darkcyan' data_id='' onclick='chooseVar(this)'>请选择变量1</span>"
		htmlOne=htmlOne+"  <span class='line-red' onclick='chooseOpera(this)'>请选择比较操作符</span>"
		htmlOne=htmlOne+"  <span class='blank' onclick='chooseType(this)'>&nbsp;</span>"
		htmlOne=htmlOne+"  <span></span>" //2020-11-16 为了放请输入值等 
		htmlOne=htmlOne+"  <span></span>" //2020-11-13
		htmlOne=htmlOne+"	</span>"
		htmlOne=htmlOne+"	<span class='icon icon-cancel' onclick='deleteCon(this)'>&nbsp;</span>"
		htmlOne=htmlOne+"</div>"
  //$($("#line>div")).append(htmlOne);
  //var rtn=$("#line").html()+htmlOne;
  //$($("#line")).html(rtn);
  $("#PathCon").append(htmlOne);
}

//画逻辑-append
function displayPathLogicAppend(xLev, yLev)
{
		var left=(xLev-1)*75+5;
	 var top=(yLev-1)*30+5;
	 var HtmlLog= "<span class='PathLog' style='position: absolute; left: "+left+"px; top: "+top+"px;'>";
	 //HtmlLog=HtmlLog+ " <span style='font-size: 11pt'>或者</span><i class='glyphicon glyphicon-chevron-down rule-join-node'></i></span>";
	 HtmlLog=HtmlLog+" <input id='"+xLev+"Box"+yLev+"' class='hisui-combobox' style='width:65px;'/></span>";
  var id=xLev+"Box"+yLev; //2020-11-04 st
	 setTimeout(function(){ 
	 		 displayCombobox(id,"and");
	 }, 0.01); //ed
	 $("#PathLog").append(HtmlLog)
}

///逻辑下拉框
function displayCombobox(id,type)
{
		var pathYEd=(function(){ //2020-11-11 st 找应该的yEd
	  'use strict'
	  return  function fun(pathData,yRtn){
			    pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
							if(pathData!=undefined){
								yRtn=parseInt(pathData.split("P")[2]);
								var pathDataX=parseInt(pathData.split("P")[0]);
								var pathDataYEd=parseInt(pathData.split("P")[2]);
								var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
								var yRtn=fun(pathData,yRtn);
							}
		     return yRtn;
	  }   
	})()
	var getRealYEd=pathYEd; //ed

	var x1=parseInt(id.split("Box")[0]); //202001125 给逻辑以出身st
	var y1=parseInt(id.split("Box")[1]);
	var lastPath=(x1-1)+"P"+y1;
	var lastData=$("#"+lastPath).attr("data");
	$("#"+id).attr("path",lastData); //ed
 
	var selVal = "";
	$HUI.combobox("#"+id,{
		valueField:'value',
		textField:'text',
		panelHeight:"210",
		mode:'remote',
		data:selectBox,
		onSelect:function(ret){
			if(selVal != ""){
				$HUI.combobox("#"+id).setValue(selVal);
			}
			var x1=parseInt(id.split("Box")[0]);
			var y1=parseInt(id.split("Box")[1]);
			if(ret.value=="additem") //添加条件
			{
				pathData=id.replace("Box","P")+"P"; //2020-11-11 st
				var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
				//alert(pathData+"  pathData  "+numPath)
				if(numPath==0){
					var y2=y1;
				}else{
					 yRtn=getRealYEd(pathData);
					 /*var yRtn="";
					 pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
						if(pathData!=undefined){
							yRtn=parseInt(pathData.split("P")[2]);
							var pathDataX=parseInt(pathData.split("P")[0]);
							var pathDataYEd=parseInt(pathData.split("P")[2]);
							var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
							pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
							if(pathData!=undefined){
								yRtn=parseInt(pathData.split("P")[2]);
								var pathDataX=parseInt(pathData.split("P")[0]);
								var pathDataYEd=parseInt(pathData.split("P")[2]);
								var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
								pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
							}
						}*/
					resetHtmlAdd(x1,yRtn);
					var y2=yRtn+1;//y2=y1+numPath;
					//resetHtmlAdd(x1,y2-1);
				}//ed	
				displayPathAppend(x1,y1,y2); //画path
				displayPathConAppend(x1,y1,y2); //画con
			}
			if(ret.value=="addunionitem"){ //添加联合条件
				var x2=parseInt(x1)+1;
				pathData=id.replace("Box","P")+"P"; //2020-11-11 st
				var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
				//alert(pathData+"  pathData  "+numPath)
				if(numPath==0){
					y2=y1;
				}else{
					yRtn=getRealYEd(pathData);
					resetHtmlAdd(x1,yRtn);
					y2=yRtn+1;
					//y2=y1+numPath;
					//resetHtmlAdd(x1,y2-1);
				}//ed	
			 displayPathAppend(x1,y1,y2); //画path
   	displayPathLogicAppend(x2,y2); //画logic
	  }
	  if(ret.value=="del"){
		  //alert(x1+"*"+y1+"*"+id)
		  if($("#PathCon").find("[data^="+x1+"P"+y1+"]").size()){
			  $.messager.alert("提示:","请先删除当前连接下子元素！");
			  return;
			 }
			 var bOXId=(parseInt(x1)+1)+"Box"+y1; //2020-11-10 st 逻辑框1-逻辑框2时，逻辑框1不能被删除；
		  var number=$("#PathLog").find("#"+bOXId).size();
		  if(number>0){
			  $.messager.alert("提示:","请先删除当前连接下子元素！");
			  return;
			 } //ed
		  deleteLogic(x1,y1,id);
		  //resetHtml(x1,y1); //2020-11-10 判断满足number小于1再调用
		  var bOXId=(parseInt(x1)-1)+"Box"+y1; //2020-11-10 st 逻辑同行时（逻辑框1-逻辑框2）,删除逻辑2不需resetHtml和减小高度
		  var number=$("#PathLog").find("#"+bOXId).size();
		  var bOXId=bOXId.replace("Box","P")+"P";
		  var numberPath=$("#line").find("path[data^='"+bOXId+"']").size(); //2020-11-10 有同父的同级的path时，即使满足number=1，也要reset
		  //alert(number+"*"+numberPath)
		  if((number<1)||(numberPath>0)){ //if(number<1){
			  resetHtml(x1,y1);
			  height=$("#line>div:first").height()-30; //2020-11-10 st 删除逻辑的同时,调整高度
 				$("#line>div:first").height(height); //ed
			 } //ed
		  //alert(bOXId+" bOXId "+number)
		  
		  $(".combo-p").css("display","none");
		  return;
		 }
			
		},
		onChange:function(newValue,oldValue)
		{
			if((newValue != "and")&&(newValue != "or")&&(newValue != "union"))
			{
				selVal = oldValue;
				$HUI.combobox("#"+id).setValue(oldValue);
			}else{
				selVal = newValue;
			}
			
		},
		onLoadSuccess:function(data)
  {
	   //alert(id+"*"+type)
    $HUI.combobox("#"+id).setValue(type);
  }
	})
}

///逻辑下拉框的选择
function initCombobox()
{
	var selVal = "";
	$HUI.combobox("#selBox",{
		valueField:'value',
		textField:'text',
		panelHeight:"210",
		mode:'remote',
		data:selectBox,
		onSelect:function(ret){
			if(selVal != ""){
				$HUI.combobox("#selBox").setValue(selVal);
			}
			if((ret.value != "and")&&(ret.value != "or")&&(ret.value != "union"))
			{
				var y1=2
				var y2=2
				var y2=y2+count
				count = count+1
				var retval = displayPathAppend(1,y1,y2);
				//displayPathSpan(1,y2,ret.value)
			}
			
		},
		onChange:function(newValue,oldValue)
		{
			if((newValue != "and")&&(newValue != "or")&&(newValue != "union"))
			{
				selVal = oldValue;
				$HUI.combobox("#selBox").setValue(oldValue);
			}else{
				selVal = newValue;
			}
			
		},
		onLoadSuccess:function(data)
        {
           $HUI.combobox("#selBox").setValue("or");
        }
	})
}

///删除动作
function deleteAction(action){
	//$(action).parent().empty();
	$(action).parent().remove();
}

///删除Con+path
function deleteCon(Con){
	var pathId=$(Con).parent().attr("data");
	$(Con).parent().remove();
	$("#"+pathId).remove();
	var conId=$(Con).parent().attr("id").split("T")[0]+"P";
	var number=$("#line").find("path[data^='"+conId+"']").size(); //2020-11-09
	//alert(conId+"*"+number)
	//resetHtmlByCon(pathId.split("P")[0],pathId.split("P")[1]);//2020-11-06
	if(number!=0){ //2020-11-09 st
		resetHtmlByCon(pathId.split("P")[0],pathId.split("P")[1]);
		height=$("#line>div:first").height()-30; //2020-11-09 st 删除内容的同时,调整高度
 	$("#line>div:first").height(height); 
	}
	
}

///删除Logic+path
function deleteLogic(x1,y1,id){
	var pathId=(x1-1)+"P"+y1;
	$("#"+id).parent().remove();
	$("#"+pathId).remove();	
}

///删除logic后需上移内容上移；
function resetHtml(x1,y1){
 $("#PathLog").find(".PathLog").each(function(){ //logic
	  var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
	  var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); //2020-11-10
	 	if(seatY>y1){
		 	seatT=$(this).css('top').split("px")[0]-30+"px";
		 	$(this).css("top",seatT);
		 	
		 	var seatId=seatX+"Box"+(seatY-1); //2020-11-10 st 被上移逻辑id同步修改
			 $(this).find("input").attr("id",seatId);
			 var type=$HUI.combobox("#"+seatId).getValue();
			 displayCombobox(seatId,type); //ed
		 }  
	});
	
	$("#PathCon").find("div").each(function(){ //content
	  var seatY=parseInt($(this).attr('data').split("P")[1]);
	  var seatX=parseInt($(this).attr('data').split("P")[0]); //2020-11-10
	 	if(seatY>y1){
		 	seatT=$(this).css('top').split("px")[0]-30+"px";
		 	$(this).css("top",seatT);
		 	
		 	var seat=seatX+"P"+(seatY-1); //2020-11-10 st 对应修改con的data和id
		 	$(this).attr("data",seat); 
		 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0])-1;
		 	if(seatY==0){seatY=1;}
		 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])-1);
		 	$(this).attr("id",seatId); //ed
		 }  
	});
	
	$("#line").find("path").each(function(){ //path
	  var seatY=parseInt($(this).attr('id').split("P")[1]);
	  var seatX=parseInt($(this).attr('id').split("P")[0]); //2020-11-10
	  if(seatY>y1){
			 	seatD=$(this).attr('d'); //修改path的d
			 	seatDOne=seatD.split("C")[0]; //2020-11-10 st
			 	seatDTwo=seatD.split("C")[1];
			 	//alert($(this).attr('data')+"   "+seatD+"   "+parseInt(seatDOne.split(",")[1]))
			 	seatDataX=parseInt($(this).attr('data').split("P")[0]);
			 	seatDataY=parseInt($(this).attr('data').split("P")[1]);
			 	seatDataYEd=parseInt($(this).attr('data').split("P")[2]);
     if(seatDataY>y1){ //y起始大于当前y1,则-30,否则不变
			 		seatDOneNew=seatDOne.split(",")[0]+","+(parseInt(seatDOne.split(",")[1])-30);
     }else{
	     seatDOneNew=seatDOne;
	    }
			 	seatDY=seatDTwo.split(",")[5];
			 	seatDYOld=","+seatDY;
			 	seatDYNew=","+(seatDY-30);
			 	seatDTwoNew=seatDTwo.replaceAll(seatDYOld,seatDYNew);
			 	seatD=seatDOneNew+"C"+seatDTwoNew; //ed
			 	$(this).attr("d",seatD);
			 	
			 	var seat=seatX+"P"+(seatY-1); //2020-11-10 st 同步path的data和id
			 	$(this).attr("id",seat);
			 	var seat=seatDataX+"P"+(seatDataY-1)+"P"+(seatDataYEd-1);
			 	if(seatDataY<=y1){ //y起始小于当前y1,y起始不变
				 	var seat=seatDataX+"P"+seatDataY+"P"+(seatDataYEd-1);
				 }
			 	$(this).attr("data",seat);  //ed
			 }  
	});

}

///删除Con后需上移内容上移；
function resetHtmlByCon(x1,y1){
	//var str=x1+"Box"+y1;
	//if(!map.has(str)){
		$("#PathCon").find("div").each(function(){ //content
		  var seatY=parseInt($(this).attr('data').split("P")[1]);
		  var seatX=parseInt($(this).attr('data').split("P")[0]); //2020-11-09
		 	if(seatY>y1){
			 	seatT=$(this).css('top').split("px")[0]-30+"px";
			 	$(this).css("top",seatT);
			 	var seat=seatX+"P"+(seatY-1); //2020-11-09 st 对应修改con的data和id
			 	$(this).attr("data",seat); 
			 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0]);
			 	if(seatY>y1){seatY=seatY-1;} //y起始大于y1时，y起始-1
			 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])-1);
			 	//alert(seatId)
			 	$(this).attr("id",seatId); //ed
			 }  
		});
		
		$("#PathLog").find(".PathLog").each(function(){ //logic
		  var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
		  var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); //2020-11-09
		 	if(seatY>y1){
			 	seatT=$(this).css('top').split("px")[0]-30+"px";
			 	$(this).css("top",seatT);
			 	var seatId=seatX+"Box"+(seatY-1); //2020-11-09
			 	$(this).find("input").attr("id",seatId); //2020-11-09
			 	var type=$HUI.combobox("#"+seatId).getValue();
			 	displayCombobox(seatId,type);
			 }  
		});
		
		var pathStr="";
		$("#line").find("path").each(function(){ //path
				var seatX=parseInt($(this).attr('id').split("P")[0])
		  var seatY=parseInt($(this).attr('id').split("P")[1]);
		 	if(seatY>y1){
			 	if(pathStr==""){
				 	pathStr=$(this).attr('data');
				 }else{
					 pathStr=pathStr+"^"+$(this).attr('data');
					}
			 	$(this).remove();
			 }  
		});
		//alert(pathStr);
		if(pathStr=="")return; //2020-11-09
		for(h=0;h<pathStr.split("^").length;h++){
					var seatXSt=pathStr.split("^")[h].split("P")[0];
	    var seatYSt=parseInt(pathStr.split("^")[h].split("P")[1]);
	    var seatYEd=parseInt(pathStr.split("^")[h].split("P")[2]);
			  seatYStNew=seatYSt-1;
		   if(seatYSt<=y1){ 
			   seatYStNew=seatYSt;
			  }
			  if((seatYSt>y1)&&(seatYEd>y1)){
			   seatYStNew=seatYSt-1;
			  }
		   seatYEdNew=seatYEd-1;
		   //alert(pathStr.split("^")[h]+"    -  "+seatXSt+", "+seatYStNew+", "+seatYEdNew)
	    //alert(seatXSt+", "+seatYStNew+", "+seatYEdNew)
					displayPathAppend(seatXSt, seatYStNew, seatYEdNew,1);
		}
	///}else{
	//map.dalete(pathId);
 //}

}

///增加con或者logic后该下移内容下移 2020-11-11
function resetHtmlAdd(x1,y1){
 $("#PathLog").find(".PathLog").each(function(){ //logic
 	 var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); 
	  var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
	 	if(seatY>y1){
		 	seatT=(parseInt($(this).css('top').split("px")[0])+30)+"px";
		 	$(this).css("top",seatT);
		 	
		 	var seatId=seatX+"Box"+(seatY+1); // 被下移逻辑id同步修改
			 $(this).find("input").attr("id",seatId);
			 var type=$HUI.combobox("#"+seatId).getValue();
			 displayCombobox(seatId,type); //ed
		 }  
	});
	
	$("#PathCon").find("div").each(function(){ //content
		 var seatX=parseInt($(this).attr('data').split("P")[0]);
	  var seatY=parseInt($(this).attr('data').split("P")[1]);
	 	if(seatY>y1){
		 	seatT=(parseInt($(this).css('top').split("px")[0])+30)+"px";
		 	$(this).css("top",seatT);
		 	
		 	var seat=seatX+"P"+(seatY+1); //对应修改con的data和id
		 	$(this).attr("data",seat); 
		 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0])+1;
		 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])+1);
		 	$(this).attr("id",seatId); //ed
		 }  
	});

	$("#line").find("path").each(function(){ //path
		 var seatX=parseInt($(this).attr('id').split("P")[0]);
	  var seatY=parseInt($(this).attr('id').split("P")[1]);
	  if(seatY>y1){
			 	seatD=$(this).attr('d'); //修改path的d
			 	seatDOne=seatD.split("C")[0]; //2020-11-10 st
			 	seatDTwo=seatD.split("C")[1];
			 	seatDataX=parseInt($(this).attr('data').split("P")[0]);
			 	seatDataY=parseInt($(this).attr('data').split("P")[1]);
			 	seatDataYEd=parseInt($(this).attr('data').split("P")[2]);
     if(seatDataY>y1){ //y起始大于当前y1,则+30,否则不变
			 		seatDOneNew=seatDOne.split(",")[0]+","+(parseInt(seatDOne.split(",")[1])+30);
     }else{
	     seatDOneNew=seatDOne;
	    }
			 	seatDY=parseInt(seatDTwo.split(",")[5]);
			 	seatDYOld=","+seatDY;
			 	seatDYNew=","+(seatDY+30);
			 	seatDTwoNew=seatDTwo.replaceAll(seatDYOld,seatDYNew);
			 	seatD=seatDOneNew+"C"+seatDTwoNew; //ed
			 	$(this).attr("d",seatD);
			 	
			 	var seat=seatX+"P"+(seatY+1); //st 同步path的data和id
			 	$(this).attr("id",seat);
			 	var seat=seatDataX+"P"+(seatDataY+1)+"P"+(seatDataYEd+1);
			 	if(seatDataY<=y1){ //y起始小于当前y1,y起始不变
				 	var seat=seatDataX+"P"+seatDataY+"P"+(seatDataYEd+1);
				 }
			 	$(this).attr("data",seat);  //ed
			 }
	});

}

function chooseVar(attr){
	AllUlPanel()
	$("#drugattr").css("display","block");
	$("#drugattr").css("left",$(attr).offset().left);
	$("#drugattr").css("top",$(attr).offset().top+$(attr).height());
	attrsels = attr;
}
//选择比较操作符面板浮现
function chooseOpera(Opera){
	AllUlPanel();
	//$(".dropdown-menu .dropdown-context").css("display","none");
	$("#operation").css("display","block");
	$("#operation").css("left",$(Opera).offset().left);
	$("#operation").css("top",$(Opera).offset().top+$(Opera).height());
	$(Opera).attr("id","OperaActive");
}
//输入值类型面板浮现
function chooseType(Type){
	AllUlPanel();
	$("#inputType").css("display","block");
	$("#inputType").css("left",$(Type).offset().left);
	$("#inputType").css("top",$(Type).offset().top+$(Type).height());
	$(Type).attr("id","TypeActive");
}
//单位面板浮现
function chooseUnit(Unit){
	attrsels = Unit
	AllUlPanel();
	$("#unit").css("display","block");
	$("#unit").css("left",$(Unit).offset().left);
	$("#unit").css("top",$(Unit).offset().top+$(Unit).height());
	$(Unit).attr("id","UnitActive");
}
//规则面板浮现-(规则无,暂不处理)
function chooseRule(Rule){
	AllUlPanel();
	$("#rule").css("display","block");
	$("#rule").css("left",$(Rule).offset().left);
	$("#rule").css("top",$(Rule).offset().top+$(Rule).height());
	$(Rule).attr("id","RuleActive");
}
//比较操作符面板-选择触发
function OperaActive(Text){
	if(Text=="Between"){
		$("#OperaActive").text("在");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之间</strong></span>")
	}else if(Text=="在集合"){
		$("#OperaActive").text("在集合");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之中</strong></span> ")
	}else{
		$("#OperaActive").text(Text);
		$("#OperaActive").next().next().next().html(""); //置空
	}
	$("#OperaActive").next().next().html(""); //置空 11-16
	$("#OperaActive").attr("id","");
	$("#operation").css("display","none");
}
//输入值类型面板-选择触发
function TypeActive(Text){
	var TextHtml="";
	if(Text=="I1"){//输入值
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;'>"
	}
	if(Text=="I2"){//输入值(带单位)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;'>"
 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	}
	if(Text=="I3"){//输入值(上下线)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>" //viewInput2
 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	}
	if(Text=="I4"){//选择变量
	}
	if(Text=="I5"){//选择数据集
		TextHtml="<span onclick='chooseDataset(this)' data_id='1' class='line-blue'>请选择数据集</span>"
	}
	if(Text=="I6"){//选择规则
		TextHtml=	"<span class='line-purple' onclick='chooseRule(this)'>请选择规则</span>"
	}
	if($("#TypeActive").prev().prev().text()=="请选择变量1"){
		$.messager.alert("提示:","请先选择变量！");
	}
	$("#TypeActive").next().html(TextHtml); //append
	$("#TypeActive").attr("id","");
	$("#inputType").css("display","none");
}
//单位面板-选择触发
function UnitActive(Unit){
	//alert($("#UnitActive").prev().val())
	inputHide($("#UnitActive").prev()); //11-16
	$("#UnitActive").text($(Unit).text());
	$("#UnitActive").attr("id","");
	$("#unit").css("display","none");	
}
//请输入值点击事件
function viewInput(Input){
	$(Input).next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="请输入值"){text="";}
	if($(Input).parent().find("input").length==2){
		$(Input).next().next().css("display","inline");
	 text=text.replace("(","").replace(")","");
	 $(Input).next().val(text.split("-")[0]);
	 $(Input).next().next().val(text.split("-")[1]);
	}else{
	//$(Input).next().css("display","inline");
	//$(Input).css("display","none");
	//var text=$(Input).text();
 //if(text=="请输入值"){text="";}
 $(Input).next().val(text);
	}
	return;
	/*var text=$(Input).text();
 if(text=="请输入值"){text="";}
	var TextHtml=	"<span class='line-brown' onclick='viewInput(this)' style='display: none;'>请输入值</span>"
 TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='height: 20px;' value='"+text+"'/>"
	$(Input).parent().html(TextHtml);*/
	//$(Input).next().css("display","block");
	//$(Input).css("display","none");
}
//请输入值点击事件-上下线
function viewInput2(Input){
	$(Input).next().css("display","inline");
	$(Input).next().next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
 if(text=="请输入值"){text="";}
 text=text.replace("(","").replace(")","");
 $(Input).next().val(text.split("-")[0]);
 $(Input).next().next().val(text.split("-")[1]);
}
//输入值的input隐藏，变text
function inputHide(Hide){
	//alert($(Hide).parent().find("input").length)
	if($(Hide).parent().find("input").length==2){
		inputHide2(Hide);
	}else{
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	$(Hide).prev().text($(Hide).val());
	}
	/*var TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>"+$(Hide).val()+"</span>"
 TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='height: 20px;display: none;'/>"
	$(Hide).parent().html(TextHtml);*/
}
//输入值的input1隐藏，变text
function inputHide1(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	$(Hide).prev().text("("+$(Hide).val()+"-)");
}
//输入值的input2隐藏，变text
function inputHide2(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().prev().css("display","inline");
	var text=$(Hide).prev().prev().text().split("-")[0]+"-"+$(Hide).val()+")";
	$(Hide).prev().prev().text(text);
}
//输入值的input1隐藏，变text,通过input2的单击
function inputHide1B2(Hide){
	$(Hide).prev().css("display","none");
	$(Hide).prev().prev().css("display","inline");
	$(Hide).prev().prev().text("("+$(Hide).prev().val()+"-)");
}
//隐藏所有ul弹窗面板
function AllUlPanel(){
	$("#operation").css("display","none");
	$("#inputType").css("display","none");
	$("#unit").css("display","none");
	$("#rule").css("display","none");
	$("#drugattr").css("display","none");
	$("#dataset").css("display","none");
}
///属性面板的点击事件[公共-是否可以？]
function selItems(selObj)
{
	$(attrsels).attr('data_id',$(selObj).attr('data'))
	var name=$(selObj).attr('name');
	if(name==undefined){
		$(attrsels).html($(selObj).html())
	}else{
		$(attrsels).html(name+"的"+$(selObj).html())
	}
	AllUlPanel();
}
///请选择数据集事件
function chooseDataset(dataset)
{
	attrsels = dataset
	AllUlPanel();
	var dataId = $(dataset).parent().prev().prev().prev().attr("data_id");
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttr",{"attrId":dataId});
	$("#dataset").html("");
	$("#dataset").append(html);
	$("#dataset").css("display","block");
	$("#dataset").css("left",$(dataset).offset().left);
	$("#dataset").css("top",$(dataset).offset().top+$(dataset).height());
}
//保存
function saveRule(){ 
	var savejson="",ifJson="",thenJson="",elseJson="";
	var logStringMap=new Map(); //20201125
	var map = new Map(); //202001124 ifLogNum map
 ifJson=ifJson+'{'
 
 var ruleJson=(function(){ //2020-11-23 递归 前台给后台json串 st
	  'use strict'
	  return  function fun(x,ifNumCur,ifLogNumCur,logStringCur,BoxIdCur,logLenCur,pathDataCur,y){
		    var xx=x+1;
		    var ifNum="ifNum"+x; // 
      ifNum=ifNumCur;
		    var ifLogNum="ifLogNum"+x+"#"+y; //+"#"+y 20201126
		    var keyStr=ifLogNum;
		    //alert(ifLogNum+"##"+x+"##"+y)
		    if(map.has(ifLogNum)){
			    ifLogNum=map.get(ifLogNum);
			    //alert(ifLogNum+"ifLogNum")
			   }else{
				   ifLogNum=0;
				  }
		    //ifLogNum=ifLogNumCur;
		    var logString="logString"+x+"#"+y; //
		    var logKeyStr=logString; //20201125 st
      if(logStringMap.has(logKeyStr)){
			    logString=logStringMap.get(logKeyStr);
			   }else{
				   logString="";
				  }//ed
		    //alert(logString)
		    //logString=logStringCur; //20201124 注释
		    var BoxId="BoxId"+xx;
		    BoxId=BoxIdCur;
		    var logLen="logLen"+x;
		    logLen=logLenCur;
						var logStr=xx+"Box"; //逻辑起始串
	 				var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or'][path^='"+pathDataCur+"']").length;
      var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and'][path^='"+pathDataCur+"']").length;
      var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union'][path^='"+pathDataCur+"']").length;
	 	  	ifLogNum=parseInt(ifLogNum)+1;
	 	  	map.set(keyStr,ifLogNum); //20201124
				  var curLog=$HUI.combobox("#"+BoxId).getValue();//当前逻辑;
				  //alert(logString+"*"+x+"*"+xx+"*"+BoxId+"*"+curLog)
				  if(logString.indexOf(curLog)>-1){
					  return "";
				  }else{
							logString=logString+curLog;
							logStringMap.set(logKeyStr,logString); //20201124
				  }
				  //alert(logString+"  logStringNew")
				  var curLogNum=curLog+"LogNum";
				  if(curLogNum=="orLogNum"){
					  curLogNum=orLogNum;
					 }else if(curLogNum=="andLogNum"){
						 curLogNum=andLogNum;
						}else{
							curLogNum=unionLogNum;
						}
				  var flag=0;
				  if(curLogNum>1){
					  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":[{' //第二层logic
					  	flag=1;
					 }else if(curLogNum==1){
						 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":{' //第二层logic
						}					
			   var number=0;
						$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"'][path^='"+pathDataCur+"']").each(function(){
							  number=number+1;
							  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
							  var ifNumNext="ifNum"+xx,ifLogNumNext="ifLogNum"+xx,logStringNext="logString"+xx; //
							  var ifNumNext=0,ifLogNumNext=0;//内容个数计数,逻辑个数计数
         var logStringNext="";//历史不重复的逻辑串
							 	var pathData=$(this).attr("id").replace("Box","P")+"P";
							 	var conData=$(this).attr("id").replace("Box","P")+"T";
							 	var pathLenNext="pathLen"+xx,conLenNext="conLen"+xx,logLenNext="logLen"+xx;//
							 	var pathLenNext=$("#line").find("path[data^='"+pathData+"']").length;
							  var conLenNext=$("#PathCon").find("div[id^='"+conData+"']").length;
							  var logLenNext=pathLenNext-conLenNext;
							  if(conLenNext>1){//全部内容N st
									 ifJson=ifJson+'"atom": ['
									}else if(conLenNext==1){
										ifJson=ifJson+'"atom": '
									}
							  $("#PathCon").find("div[id^='"+conData+"']").each(function(){
											 var ConId=$(this).attr("id");
											 ifNumNext=ifNumNext+1;//是内容时+1
											 /*if(ifNumNext==1){
													 if(conLenNext>1){
														 ifJson=ifJson+'"atom": ['
														}else if(conLenNext==1){
															ifJson=ifJson+'"atom": '
														}
												}*/
											 ifJson=ifJson+' {"left": {},' //Constant 数据集st
												ifJson=ifJson+'"value": {},'
												var op=$("#"+ConId).find(".line-red").attr("data");//20201126
												ifJson=ifJson+'"_op": "'+op+'"}'//ed
												if(ifNumNext<conLenNext)ifJson=ifJson+','
												//if((ifNumNext==conLenNext)&&(ifNumNext!=1))ifJson=ifJson+']'
												//if((ifNumNext==conLenNext)&&((ifNumNext<pathLenNext)))ifJson=ifJson+','
							  })
							  if(conLenNext>1)ifJson=ifJson+']'
         if((conLenNext!=0)&&(conLenNext<pathLenNext))ifJson=ifJson+','//全部内容N ed

							  $("#line").find("path[data^='"+pathData+"']").each(function(){
											 var data=$(this).attr("data");
											 var x=parseInt(data.split("P")[0]);
											 var y=parseInt(data.split("P")[1]);
											 var yEd=parseInt(data.split("P")[2]);
											 var ConId=x+"P"+y+"T"+yEd;
											 var BoxIdNext="BoxId"+(x+1);
											 BoxIdNext=(x+1)+"Box"+yEd;
											 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
											 if(con<1){//是逻辑第四层st
											 
            	 var rtnStr=fun(x,ifNumNext,ifLogNumNext,logStringNext,BoxIdNext,logLenNext,pathData,y);		
											 
									   }//第四层是逻辑ed
						   })
					 })

	     ifJson=ifJson+'}'
	     if(flag==1)ifJson=ifJson+']' 
	     //alert(ifLogNum+"**"+logLen+"**"+orLogNum+"**"+andLogNum+"**"+unionLogNum)
	     //if((logString!="or")&&(logString!="and")&&(logString!="union")){//20201127 只有一层逻辑时，不必逗号
	     if((orLogNum!=logLen)&&(andLogNum!=logLen)&&(unionLogNum!=logLen)){//20201127 只有一层逻辑时，不必逗号
	     if(ifLogNum<logLen)ifJson=ifJson+','
	     }
	     //return logString+"^"+ifLogNum;
	  }   
	})()
	var getRuleJson=ruleJson; //ed
 
 //var elseNum=0;
 var pathData="1P1P",conData="1P1T",BoxId="1Box1";
 ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":{' //第一个logic
 var pathLen=$("#line").find("path[data^='"+pathData+"']").length;
 var conLen=$("#PathCon").find("div[id^='"+conData+"']").length;
 var logLen=pathLen-conLen;
 var logStr="2Box"; ////逻辑ID串
 var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or']").length;
	var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and']").length;
	var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union']").length;
 var ifNum=0,ifLogNum=0;//内容计数，逻辑计数
 var logString=""; //历史逻辑，不重复
 if(conLen>1){ //全部内容1 st
	 ifJson=ifJson+'"atom": ['
	}else if(conLen==1){
		ifJson=ifJson+'"atom": '
	}
 $("#PathCon").find("div[id^='"+conData+"']").each(function(){
	 var ConId=$(this).attr("id");
			 ifNum=ifNum+1;//是内容时+1
			 /*if(ifNum==1){
					 if(conLen>1){
						 ifJson=ifJson+'"atom": ['
						}else if(conLen==1){
							ifJson=ifJson+'"atom": '
						}
				}*/
			 ifJson=ifJson+' {"left": {},' //Constant 数据集st
				ifJson=ifJson+'"value": {},'
				var op=$("#"+ConId).find(".line-red").attr("data");//20201126
				ifJson=ifJson+'"_op": "'+op+'"}'//ed
				if(ifNum<conLen)ifJson=ifJson+','
				//if((ifNum==conLen)&&(conLen>1))ifJson=ifJson+']'
    //if((ifNum==conLen)&&(ifNum<pathLen))ifJson=ifJson+','
 })
 if(conLen>1)ifJson=ifJson+']'
 if((conLen!=0)&&(conLen<pathLen))ifJson=ifJson+','//全部内容1 ed

	$("#line").find("path[data^='"+pathData+"']").each(function(){ //逻辑1 st
	 var data=$(this).attr("data");
	 var x=parseInt(data.split("P")[0]);
	 var y=parseInt(data.split("P")[1]);
	 var yEd=parseInt(data.split("P")[2]);
	 var ConId=x+"P"+y+"T"+yEd;
	 var BoxId2=(x+1)+"Box"+yEd;
	 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
	 if(con<1){//是逻辑1st
		   rtnStr=getRuleJson(x,ifNum,ifLogNum,logString,BoxId2,logLen,pathData,y); //ifLogNumCur,logStringCur==（ifLogNum,logString） 这俩参数理论上不再需要
			  /*ifLogNum=ifLogNum+1;
			  var curLog=$HUI.combobox("#"+BoxId2).getValue();//当前逻辑;
			  if(logString.indexOf(curLog)>-1){
				  return true;
			  }else{
						logString=logString+curLog;
			  }
			  var curLogNum=curLog+"LogNum";
			  if(curLogNum=="orLogNum"){
				  curLogNum=orLogNum;
				 }else if(curLogNum=="andLogNum"){
					 curLogNum=andLogNum;
					}else{
						curLogNum=unionLogNum;
					}
			  var flag=0;
			  if(curLogNum>1){
				  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId2).getValue()+'":[{' //第二层logic
				  	flag=1;
				 }else if(curLogNum==1){
					 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId2).getValue()+'":{' //第二层logic
					}					
		   var number=0;//该逻辑个数计数
					$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"'][path^='"+pathData+"']").each(function(){
						  number=number+1;
						  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
						  var ifNum2=0,ifLogNum2=0;//内容个数计数,逻辑个数计数
						  var logString2="";//历史不重复的逻辑串
						 	var pathData=$(this).attr("id").replace("Box","P")+"P";
						 	var conData=$(this).attr("id").replace("Box","P")+"T";
						 	var pathLen2=$("#line").find("path[data^='"+pathData+"']").length;
						  var conLen2=$("#PathCon").find("div[id^='"+conData+"']").length;
						  var logLen2=pathLen2-conLen2;
						  $("#line").find("path[data^='"+pathData+"']").each(function(){
										 var data=$(this).attr("data");
										 var x=parseInt(data.split("P")[0]);
										 var y=parseInt(data.split("P")[1]);
										 var yEd=parseInt(data.split("P")[2]);
										 var ConId=x+"P"+y+"T"+yEd;
										 var BoxId3=(x+1)+"Box"+yEd;
										 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
										 if(con>0){//是内容
												 ifNum2=ifNum2+1;//是内容时+1
												 if(ifNum2==1){
														 if(conLen2>1){
															 ifJson=ifJson+'"atom": ['
															}else if(conLen2=1){
																ifJson=ifJson+'"atom": '
															}
													}
												 ifJson=ifJson+' {"left": {},' //Constant 数据集st
													ifJson=ifJson+'"value": {},'
													var op=$("#"+ConId).find(".line-red").attr("data");//20201126
													ifJson=ifJson+'"_op": "'+op+'"}'//ed
													if(ifNum2<conLen2)ifJson=ifJson+','
													if((ifNum2==conLen2)&&(ifNum2!=1))ifJson=ifJson+']'
													if((ifNum2==conLen2)&&((ifNum2<pathLen2)))ifJson=ifJson+','
										 }else{//是逻辑2st
										     //alert("fun"+ConId)
										     rtnStr=getRuleJson(x,ifNum2,ifLogNum2,logString2,BoxId3,logLen2,pathData,y); //ifLogNumCur,logStringCur==（ifLogNum2,logString2） 这俩参数理论上不再需要
										 				/*var logStr=(x+1)+"Box"; //
										 				var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or']").length;
	              var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and']").length;
	              var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union']").length;
										 	  	ifLogNum2=ifLogNum2+1;
													  var curLog=$HUI.combobox("#"+BoxId3).getValue();//当前逻辑;
													  if(logString2.indexOf(curLog)>-1){
														  return true;
													  }else{
																logString2=logString2+curLog;
													  }
													  var curLogNum=curLog+"LogNum";
													  if(curLogNum=="orLogNum"){
														  curLogNum=orLogNum;
														 }else if(curLogNum=="andLogNum"){
															 curLogNum=andLogNum;
															}else{
																curLogNum=unionLogNum;
															}
													  var flag=0;
													  if(curLogNum>1){
														  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId3).getValue()+'":[{' //第二层logic
														  	flag=1;
														 }else if(curLogNum==1){
															 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId3).getValue()+'":{' //第二层logic
															}					
												   var number=0;
															$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"'][path^='"+pathData+"']").each(function(){
																  number=number+1;
																  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
																  var ifNum3=0,ifLogNum3=0;//内容个数计数,逻辑个数计数
																		var logString3="";//历史不重复的逻辑串
																 	var pathData=$(this).attr("id").replace("Box","P")+"P";
																 	var conData=$(this).attr("id").replace("Box","P")+"T";
																 	var pathLen3=$("#line").find("path[data^='"+pathData+"']").length;
																  var conLen3=$("#PathCon").find("div[id^='"+conData+"']").length;
																  var logLen3=pathLen3-conLen3;
																  $("#line").find("path[data^='"+pathData+"']").each(function(){
																				 var data=$(this).attr("data");
																				 var x=parseInt(data.split("P")[0]);
																				 var y=parseInt(data.split("P")[1]);
																				 var yEd=parseInt(data.split("P")[2]);
																				 var ConId=x+"P"+y+"T"+yEd;
																				 var BoxId4=(x+1)+"Box"+yEd;
																				 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
																				 if(con>0){//是内容
																						 ifNum3=ifNum3+1;//是内容时+1
																						 if(ifNum3==1){
																								 if(conLen3>1){
																									 ifJson=ifJson+'"atom": ['
																									}else if(conLen3=1){
																										ifJson=ifJson+'"atom": '
																									}
																							}
																						 ifJson=ifJson+' {"left": {},' //Constant 数据集st
																							ifJson=ifJson+'"value": {},'
																							ifJson=ifJson+'"_op": "Equals"}'//ed
																							if(ifNum3<conLen3)ifJson=ifJson+','
																							if((ifNum3==conLen3)&&(ifNum3!=1))ifJson=ifJson+']'
																							if((ifNum3==conLen3)&&((ifNum3<pathLen3)))ifJson=ifJson+','
																				 }else{//是逻辑第三层st

																		   }//第三层是逻辑ed 
															   })
														 })

										     ifJson=ifJson+'}'
										     if(flag==1)ifJson=ifJson+']' 
										     alert(ifLogNum2+"**"+logLen2)
										     if(ifLogNum2<logLen2)ifJson=ifJson+','  //*/
				/*						     
								   }//第二层是逻辑ed  

					   })
				 })

     ifJson=ifJson+'}'
     if(flag==1)ifJson=ifJson+']' 
     //alert(logString)
     alert(ifLogNum+"*"+logLen)
     //if((logString!="or")&&(logString!="and")&&(logString!="union")){//20201127 只有一层逻辑时，不必逗号
     if((orLogNum!=logLen)&&(andLogNum!=logLen)&&(unionLogNum!=logLen)){//20201127 只有一层逻辑时，不必逗号
     if(ifLogNum<logLen)ifJson=ifJson+','
     } //*/
			}//第一层是逻辑ed
		
	})//each1 ed

	ifJson=ifJson+'}' //第一个logic结束
	ifJson=ifJson+'}' //if结束 ifJson=ifJson+'},' //if结束
	alert(ifJson)
	
	return; //
	
	var thenNum=0,thenLen=$("#then").find(".rule-action").length;
	$("#then>.rule-action").each(function(){ //then
		thenNum=thenNum+1;
		//alert($(this).attr("id"))
		if($(this).find(".line-brown").length>0){
			thenJson=thenJson+'{"value":{"_ruleData":"0",'
			var content=$(this).find(".line-brown").text();
			thenJson=thenJson+'"_content":"'+content+'",'
			thenJson=thenJson+'"_type":"Input"},'
		}else{
			thenJson=thenJson+'{"value":{'
			thenJson=thenJson+'"_ruleData":"'+$(this).attr("id")+'",'
			thenJson=thenJson+'"_const-category":"undefined",'
			thenJson=thenJson+'"_const":"'+$(this).find(".line-blue").attr("id")+'",'
			thenJson=thenJson+'"_const-label":"'+$(this).find(".line-blue").text()+'",'
			thenJson=thenJson+'"_type":"Constant"},'
		}
		thenJson=thenJson+'"_varCategory":"'+$(this).find(".line-darkcyan-zero").text().split("的")[0]+'",'
		thenJson=thenJson+'"_ruleData":"'+$(this).attr("id")+'",'
		thenJson=thenJson+'"_varCategoryId":"'+$(this).attr("data").split("^")[0]+'",'
		thenJson=thenJson+'"_var":"'+$(this).attr("data").split("^")[1]+'",'
		thenJson=thenJson+'"_varLabel":"'+$(this).find(".line-darkcyan-zero").text().split("的")[1]+'",'
		thenJson=thenJson+'"_datatype":"undefined",'
		thenJson=thenJson+'"_type":"variable"}'
		if(thenNum!=thenLen){
			thenJson=thenJson+','
		}
	});
	if(thenJson!=""){
		thenJson='{"var-assign":['+thenJson+']}'
	}
	//alert(thenJson)
	var elseNum=0,elseLen=$("#else").find(".rule-action").length;
 	$("#else>.rule-action").each(function(){ //else
		elseNum=elseNum+1;
		if($(this).find(".line-brown").length>0){
			elseJson=elseJson+'{"value":{"_ruleData":"0",'
			var content=$(this).find(".line-brown").text();
			elseJson=elseJson+'"_content":"'+content+'",'
			elseJson=elseJson+'"_type":"Input"},'
		}else{
			elseJson=elseJson+'{"value":{'
			elseJson=elseJson+'"_ruleData":"'+$(this).attr("id")+'",'
			elseJson=elseJson+'"_const-category":"undefined",'
			elseJson=elseJson+'"_const":"'+$(this).find(".line-blue").attr("id")+'",'
			elseJson=elseJson+'"_const-label":"'+$(this).find(".line-blue").text()+'",'
			elseJson=elseJson+'"_type":"Constant"},'
		}
		elseJson=elseJson+'"_varCategory":"'+$(this).find(".line-darkcyan-zero").text().split("的")[0]+'",'
		elseJson=elseJson+'"_ruleData":"'+$(this).attr("id")+'",'
		elseJson=elseJson+'"_varCategoryId":"'+$(this).attr("data").split("^")[0]+'",'
		elseJson=elseJson+'"_var":"'+$(this).attr("data").split("^")[1]+'",'
		elseJson=elseJson+'"_varLabel":"'+$(this).find(".line-darkcyan-zero").text().split("的")[1]+'",'
		elseJson=elseJson+'"_datatype":"undefined",'
		elseJson=elseJson+'"_type":"variable"}'
		if(elseNum!=elseLen){
			elseJson=elseJson+','
		}
	});
	if(elseJson!=""){
		elseJson='{"var-assign":['+elseJson+']}'
	}
 //alert(elseJson)
	savejson='{"rule":{"remark":"",'
	savejson=savejson+'"if":'+ifJson+','
	savejson=savejson+'"then":'+thenJson+',' //then没有时为空
	savejson=savejson+'"else":'+elseJson+','
	savejson=savejson+'"_name":"rule"'
 savejson=savejson+'}}';
	alert(savejson)
	//console.log(savejson)
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
