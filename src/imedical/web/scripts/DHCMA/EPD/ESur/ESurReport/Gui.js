//职业暴露报告--Gui
function InitReportWin() {
    var obj = new Object();
    $.parser.parse(); // 解析该页面
    
    
    //1.加载项目分类
    var htmlP = '';
    var OccDataTypes = $cm({
        ClassName: "DHCMed.EPDService.ESurRepSrv",
        QueryName: "QryESurRegType",
        aRegTypeID: RegTypeID
    }, false);
    for (var ind = 0; ind < OccDataTypes.total; ind++) {
        var OccDataType = OccDataTypes.rows[ind];
        var TypeID 		= OccDataType.TypeID;        //类型ID
        var TypeCode 	= OccDataType.TypeCode;    //类型Code
        var TypeDesc 	= OccDataType.TypeDesc;    //类型名称
        htmlP = htmlP 	+"<div id='"+TypeCode+"'>"
        				+"		<div class='hisui-panel' data-options=\"title:'" + TypeDesc + "(标注为*的项目为必填项)',headerCls:'panel-header-gray',iconCls:'icon-paper'\" style='padding:3px'>"
                      	+"			<div id='Exp" + TypeCode + "' style='margin-left:3px;'></div>"
	                  	+"		</div>"
        				+"</div>";
    }
    $("#ExpExt").html(htmlP);
	//2.加载项目存储框架
	var arr="";
	for (var i = 0; i < OccDataTypes.total; i++) {
        var OccDataType = OccDataTypes.rows[i];
        
        var TypeID = OccDataType.TypeID;		//类别ID
        var TypeCode = OccDataType.TypeCode;	//类别Code
        //项目信息
        var OccData = $cm({
            ClassName: "DHCMed.EPDService.ESurRepSrv",
	        QueryName: "QryESurTypeExtByID",
	        aTypeID: RegTypeID,
	        aExtTypeID:TypeID
        }, false);
        for (var j = 0; j < OccData.total; j++) {
            var Data = OccData.rows[j];
            var RegCode = Data.Code;  		//具体信息Code
            var ItemID = parseInt(RegCode.substring(0,4));
            //过滤重复值
            if(arr.indexOf(ItemID)>-1) continue;
            arr=arr+"^"+ItemID;
            //分割线
            var SLine="";
            if (j < OccData.total-1){
	        	SLine='<span style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
	        }
            var html 	= 	'<div id="Box'+ItemID+'" style="padding:10px;">'
                    	+ 	'	<div id="Box'+ItemID+'-1"></div>'
                        + 	'	<div id="Box'+ItemID+'-2"></div>'
                        +	'	<div style="clear:both;"></div>'	//清除浮动
                       	+ 	'	<div id="Box'+ItemID+'-3"></div>'
                      	+ 	'</div>'
                       	+ 	SLine
           	$("#Exp" + TypeCode).append(html);
        }
        
    }
    //3.加载项目信息
    for (var i = 0; i < OccDataTypes.total; i++) {
        var OccDataType = OccDataTypes.rows[i];
        var TypeID 		= OccDataType.TypeID;		//类别ID
        var TypeCode 	= OccDataType.TypeCode;	//类别Code
        //项目信息
        var OccData = $cm({
	        ClassName: "DHCMed.EPDService.ESurRepSrv",
	        QueryName: "QryESurTypeExtByID",
	        aTypeID: RegTypeID,
	        aExtTypeID:TypeID
        }, false);
        for (var j = 0; j < OccData.total; j++) {
            var Data = OccData.rows[j];

            var ExtID 	 = Data.ID;      	//具体信息ID
            var RegDesc  = Data.Desc;  		//具体信息Desc
            var RegCode  = Data.Code;  		//具体信息Code
            var DataType = Data.DatCode;  	//字典类型(文本/单选框/多选框)
            var DicCode  = Data.DicCode;   	//字典Code
            var Required = Data.IsRequired; //是否必选
            
            var Line 	 = parseInt(RegCode);
            var Last 	 = RegCode.substring(5);
            //必填项-字体加粗*
            var Label = "";
            if (Required == 1) {
                Label = "<strong><font color='red'>*</font></strong>" + RegDesc;
            }
            else {
                Label = RegDesc;
            }
            
            if (Last != 0) continue;
            
            //项目信息字典
            var ItemID = "Line" + Line;
            if (DataType == "") {   	//文字描述没有内容
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	=	'<div id="'+ItemID+'"><b>' + Label + '</b></div>'
            	
            	$("#Box"+BoxID+"-1").append(html);
            }
            else if (DataType == "DS") {  //单选字典
            	var BoxID = parseInt(RegCode.substring(0,4));
                var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
				$("#Box"+BoxID+"-1").append(html);  
                Common_RadioToDic(ItemID, DicCode, 4);		//	加载单选列表
            }
            else if (DataType == "DSL") {  //单选长字典
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-1").append(html);  
                Common_RadioToDic(ItemID, DicCode, 2);		//	加载单选列表
            }
            else if (DataType == "DB") {  //多选字典
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-1").append(html);  
                Common_CheckboxToDic(ItemID, DicCode, 4);		//	加载多选列表
            }
            else if (DataType == "DBL") {   //多选长字典
               	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-1").append(html);  
                Common_CheckboxToDic(ItemID, DicCode, 2);		//	加载多选列表
            }
            else if ((DataType == "B1") || (DataType == "B2")) {  //有无/是否	
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="width:100px;padding-right:10px;padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-1").append(html);  
                RadioToDic(ItemID, DicCode, 16,Data.DicInfoID);		//	加载是否/有无
            }
            else if (DataType == "TL") {      //大文本
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                           	+ 	'	<div><textarea class="textbox" id="' + ItemID + '" style="width:1170px; height: 80px;" placeholder="' + RegDesc + '"></textarea></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-1").append(html);  
            }
            else {
                if (DataType == "S") {       //下拉框
                	var BoxID = parseInt(RegCode.substring(0,4));
            		var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+	'	<div id="' + ItemID + '"><input class="hisui-combobox textbox" id=' + ItemID + '" style="width:187px;" /></div>'
							+	'</div>';
            		$("#Box"+BoxID+"-2").append(html);  
            		
                    $.parser.parse("#Exp" + TypeCode); // 解析该页面
            		Common_ComboDicID(ItemID, DicCode,1);  //加载数据
                }
                if ((DataType == "T") || (DataType == "N0") || (DataType == "N1")) {   //文本、数值
                	var BoxID = parseInt(RegCode.substring(0,4));
            		var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:65px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 180px;" placeholder="' + RegDesc + '...' + '"/>'
							+	'</div>';
            		$("#Box"+BoxID+"-2").append(html);  
                }
                if (DataType == "TB") {   //长文本	
                	var BoxID = parseInt(RegCode.substring(0,4));
            		var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 1060px;" placeholder="' + RegDesc + '...' + '"/>'
							+	'</div>';
            		$("#Box"+BoxID+"-1").append(html);  
                }
                if (DataType == "DD") {  //日期
                	var BoxID = parseInt(RegCode.substring(0,4));
            		var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class=\'hisui-datebox textbox\' id="' + ItemID + '"style="width:187px;"/></div>'
							+	'</div>';
            		$("#Box"+BoxID+"-2").append(html);  
                }
            }

        }
    }
    //4.加载项目扩展信息(其他...)
    for (var indz = 0; indz < OccDataTypes.total; indz++) {
        var rd = OccDataTypes.rows[indz];
        if (!rd) continue;
        var TypeID = rd["TypeID"];
        var TypeCode = rd["TypeCode"];
        var lenExt = $cm({
	        ClassName: "DHCMed.EPDService.ESurRepSrv",
	        QueryName: "QryESurTypeExtByID",
	        aTypeID: RegTypeID
        }, false);
        for (var indExt = 0; indExt < lenExt.total; indExt++) {
            var rdExt = lenExt.rows[indExt];

            var ExtID = rdExt.ID;
            var RegDesc = rdExt.Desc;
            var RegCode = rdExt.Code;
            var DataType = rdExt.DatCode;
            var DicCode = rdExt.DicCode;
            var Line = parseInt(RegCode);
            var Last = RegCode.substring(5);
            if (Last == 0) continue;
            
            //必填项-字体加粗*
            var Label = "";
            if (Required == 1) {
                Label = "<strong><font color='red'>*</font></strong>" + RegDesc;
            }
            else {
                Label = RegDesc;
            }
            var ItemID = "Line" + Line;
            
            if (DataType == "T") {	 //备注文本
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                           	+	'	<div><input class="textbox" id="' + ItemID + '" style="width: 25%;" placeholder="' + RegDesc + '...' + '"/></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-3").append(html);  
            }
            if (DataType == "TB") {	 //长文本
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                           	+	'	<div><input class="textbox" id="' + ItemID + '" style="width: 50%;" placeholder="' + RegDesc + '...' + '"/></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-3").append(html);  
            }
            if (DataType == "DS") {  //单选字典
                var BoxID = parseInt(RegCode.substring(0,4));
                var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                            + 	'	<div id="' + ItemID + '"></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
				$("#Box"+BoxID+"-3").append(html);  
                Common_RadioToDic(ItemID, DicCode, 4);		//	加载单选列表
            }
            if (DataType == "TL") {      //大文本
            	var BoxID = parseInt(RegCode.substring(0,4));
            	var html 	= 	'<div>'
                			+	'	<div style="padding-bottom:5px"><b>' + Label + '</b></div>'
                           	+	'	<div><textarea class="textbox" id="' + ItemID + '" style="width:1170px;; height: 80px;" placeholder="' + RegDesc + '"></textarea></div>'
                            +	'	<div style="clear:both;"></div>'
                            + 	'</div>'
            	$("#Box"+BoxID+"-3").append(html);  

            }
        }
    }
   

    $.parser.parse(); // 解析整个页面
//单选字典
function RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	var DicInfoID = arguments[3];
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			
			listHtml += "<div style='float:left;width:"+per+";display:inline-block'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==DicInfoID? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}

    InitReportWinEvent(obj);
    return obj;
}