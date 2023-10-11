﻿function InitComTemplateWin(obj) {
	obj.BTSCheck=1;      //单选文本体验优化
    //定义数组(默认2~10)
    obj.SumID=2;
    obj.Sum = new Array();
	obj.Sum[1]="一",obj.Sum[2]="二",obj.Sum[3]="三",obj.Sum[4]="四",obj.Sum[5]="五",obj.Sum[6]="六";
	obj.Sum[7]="七",obj.Sum[8]="八",obj.Sum[9]="九",obj.Sum[10]="十",obj.Sum[11]="十一"; 	
    //加载页签1:登记报告
    var ExtTypeIDs_1= $cm({
        ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        aExtTypeID:"",
        rows:999
    }, false);
    var html_1=""
    for (var ind = 0; ind < ExtTypeIDs_1.total; ind++) {
        var ExtTypeData = ExtTypeIDs_1.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var TypeCode = ExtTypeData.TypeCode;
        var TypeDesc = ExtTypeData.TypeDesc;
        //DIV(名称为DIV-1)
        html_1 = html_1	+"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"、"+TypeDesc + "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\" style='width:1240px;padding:5px'>"
                      	+"	<div id='DIV" + TypeID + "' style='margin:0px 10px 0px 10px;'></div>"
	                  	+"</div>";
	    obj.SumID++;
    }
    $('#ComTemplateInfo').html(html_1);
    $.parser.parse('#ComTemplateInfo'); 		// 解析页签1
	for (var ind = 0; ind < ExtTypeIDs_1.total;ind++) {
        var ExtTypeData = ExtTypeIDs_1.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var Data = $cm({
            ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
            QueryName: "QryExtByType",
            aTypeID: RegTypeID,
            aExtTypeID: TypeID,
            rows:999
        }, false);
      	//(存储临时数据)  
    	var arr="";		
        //获取项目列表
        for(var jnd = 0; jnd < Data.total; jnd++) {
            var ItemData = Data.rows[jnd];
            var Code = ItemData.Code;  	
            var BoxID = TypeID+"-"+parseInt(Code.substring(2,4));
            //过滤重复值
            if(arr.indexOf(BoxID)>-1) continue;
            arr=arr+"^"+BoxID;
        }
        for(var knd = 1; knd < arr.split("^").length; knd++){
	    	var BoxID = arr.split("^")[knd];
	    	
	    	//构建Box
	    	var SLine="";
	    	if(knd<(arr.split("^").length-1)){
		    	var SLine=SLine='<span class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
		    }
            
            var html 	= 	'<div id="Box'+BoxID+'" style="padding-top:5px;">'
                    	+ 	'	<div id="Box'+BoxID+'-1"></div>'	//主框架[XX01XX]
                    	+	'	<div style="clear:both;"></div>'	//清除浮动
                        + 	'	<div id="Box'+BoxID+'-2""></div>'	//扩充框架[XX0101]
                      	+ 	'</div>'
           	$("#DIV" + TypeID).append(html);
	    }
    }
    //加载页签[内容]:填充内容(详细见文档)--工龄、年龄....
    for (var ind = 0; ind < ExtTypeIDs_1.total; ind++) {
        var ExtTypeData = ExtTypeIDs_1.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;	//暴露信息、暴露源信息
        var Data = $cm({
            ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
            QueryName: "QryExtByType",
            aTypeID: RegTypeID,
            aExtTypeID: TypeID,
            rows:999
        }, false);
        for (var jnd = 0; jnd < Data.total; jnd++) {
            var ItemData = Data.rows[jnd];	//工龄、职别...

            var ID = ItemData.ID.split("||")[1];//1
            var Code = ItemData.Code;			//020110
            var Desc = ItemData.Desc			//工龄
           	var DataType = ItemData.DatCode;  	//文本、单选框、多选框
            var DicCode = ItemData.DicCode;   	//OEWorkAge
            var Required = ItemData.IsRequired; //1
           	
           	var IsItemExt = parseInt(Code.substring(5));		//是否扩充备注
           	var ExtID=1;
         	if(IsItemExt!=0)ExtID=2;
	        //BoxID(内容Box)
	        var BoxID = TypeID+"-"+parseInt(Code.substring(2,4))+"-"+ExtID;
	        
	        var ItemID = parseInt(Code);
	        //字体加粗(必填项)*
          	var Label = "";
          	if (Required == 1) {
            		Label = "<strong><font color='red'>*</font></strong>" + Desc;
          	}
           	else {
         		Label = Desc;
         	}
	     	//(1):文字描述
	     	if (DataType == "") {   	
       			var html='<div id="'+ItemID+'"><b>' + Label + '</b></div>'
           		$("#Box"+BoxID).append(html);
       		}
            //(2):单选字典
	      	else if (DataType == "DS") {  //单选字典
             	var html 	= 	'<div>'
           					+	'	<div><b>' + Label + '</b></div>'	//描述
                            + 	'	<div id="' + ItemID + '"></div>'	//单选列表
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//清除浮动
				$("#Box"+BoxID).append(html);  
				//加载单选列表(默认4列)
                Common_RadioToDic(ItemID, DicCode, 4);		
            }
            //(3):单选长字典
            else if (DataType == "DSL") {
            	var html 	= 	'<div>'
               				+	'	<div><b>' + Label + '</b></div>'	//描述
                           	+ 	'	<div id="' + ItemID + '"></div>'	//单选列表
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//清除浮动
            	$("#Box"+BoxID).append(html);  
            	//加载单选列表(默认2列)
                Common_RadioToDic(ItemID, DicCode, 2);		
            }
            //(4):多选字典
            else if (DataType == "DB") {  
            	var html 	= 	'<div>'
                			+	'	<div><b>' + Label + '</b></div>'	//描述
                           	+ 	'	<div id="' + ItemID + '"></div>'	//单选列表
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//清除浮动
            	$("#Box"+BoxID).append(html); 
            	//加载多选列表 (默认4列)
               	Common_CheckboxToDic(ItemID, DicCode, 4);		
           	}
            //(5):多选长字典
            else if (DataType == "DBL") { 
            	var html 	= 	'<div>'
               				+	'	<div><b>' + Label + '</b></div>'	//描述
                           	+ 	'	<div id="' + ItemID + '"></div>'	//单选列表
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//清除浮动
            	$("#Box"+BoxID).append(html); 
            	//加载多选列表 (默认2列)
               	Common_CheckboxToDic(ItemID, DicCode, 2);
            }
           	//(6):有无|是否
            else if ((DataType == "B1") || (DataType == "B2")) {
            	var html 	= 	'<div>'
               				+	'	<div><b>' + Label + '</b></div>'	//描述
                           	+ 	'	<div id="' + ItemID + '"></div>'	//单选列表
                           	+ 	'</div>'
                           	+	'<div style="clear:both;"></div>'	//清除浮动
            	$("#Box"+BoxID).append(html); 
            	//加载是否|有无;  
               	Common_RadioToDic(ItemID, DicCode, 4);
            }
            //(7):大文本
            else if (DataType == "TL") { 
            	var html 	= 	'<div>'
                			+	'	<div><b>' + Label + '</b></div>'
                        	+ 	'	<div><textarea class="textbox" id="' + ItemID + '" style="width:1170px; height: 80px;""></textarea></div>'
                           	+ 	'</div>'
            	$("#Box"+BoxID).append(html); 
           	 }
           	 //(8):下拉框
           	 else if (DataType == "S") {    
            	var html=	'<div style="float:left;width:25%;">'
						+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'	//描述
						+	'	<input class="hisui-combobox textbox" id="' + ItemID + '" style="width:187px;" />'	//下拉列表
						+	'</div>';
            	$("#Box"+BoxID).append(html);  
            		
                $.parser.parse("#Box"+BoxID); // 解析该页面
            	Common_ComboDicID(ItemID, DicCode,1);  //加载数据
          	}
          	//(9):文本、数值
           	if ((DataType == "T") || (DataType == "N0") || (DataType == "N1")) {
	           	var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 180px;" />'
							+	'</div>';
            	$("#Box"+BoxID).append(html);   
        	}
          	if (DataType == "TB") {   //长文本	
            	var html=	'<div>'
            				+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 1060px;" placeholder="' + Desc + '..."/>'
							+	'</div>';
            	$("#Box"+BoxID).append(html);  
                 $.parser.parse("#Box"+BoxID); // 解析该页面 
        	}
           	if (DataType == "DD") {  //日期
            	var html=	'<div style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class=\'hisui-datebox textbox\' id="' + ItemID + '"style="width:187px;"/></div>'
							+	'</div>';
           		$("#Box"+BoxID).append(html); 
           		$.parser.parse("#Box"+BoxID); // 解析该页面 
       		}
            if (DataType=="DST"){
                 // 单选文本
                 var html    =   '<div>'
                            +   '   <div><b>' + Label + '</b></div>'    //描述
                            +   '   <div id="' + ItemID + '"></div>'    //单选列表
                            +   '</div>'
                            // +   '   <input class="textbox" id="' + ItemID + '" style="width: 430px;" />'
                            +   '<div style="clear:both;"></div>'   //清除浮动
                $("#Box"+BoxID).append(html); 
                Common_RadioTextToDic(ItemID, DicCode, 2,1); 
				//绑定选中事件
				if (obj.BTSCheck==1) {
					$HUI.radio("[name='"+ItemID+"']", {
						onChecked: function () {
							var nextInput=$(this).next().next()
							var _name=$(this).attr("name")
							
							var _text=nextInput.val();
							var _id=nextInput[0].id
							nextInput.focus();
							_text=$.trim(_text)
							if (_text!=""){
								// 既然已经有值,同类为空
								
								$("input[id^='"+_name+"']").each(function () {
									if ($(this)[0].id!=_id){
										$(this).val("");
									}
			　　				}) 
							}
						}
					});
					$("input[id^='"+ItemID+"']").each(function () {
						var _this=$(this);
						$(this).blur(function(){
							var _value=_this.val();
							_value=$.trim(_value)
							var rId=_this.prevAll("input")[0]
							if (_value!="") {
								//触发选中事件
								
								 $HUI.radio(rId).setValue(true);
							}
						})
　　				}) 
				}//结束绑定选中事件
            }
        }
    }
    InitReportWinEvent(obj);
    return obj;
}