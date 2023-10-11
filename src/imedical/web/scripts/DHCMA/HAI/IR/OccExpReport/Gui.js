//职业暴露报告[GUI]
var obj = new Object();
obj.BTSCheck=1;      //cjb20230220单选文本体验优化
function InitReportWin() {
    //初始化下拉菜单1->[性别]
    //多语言翻译取男女
	obj.SexNLng = $m({          //当前页(默认最后一页)
        ClassName: "DHCHAI.Abstract",
        MethodName: "HAIGetTranByDesc",
        aProp: "CTSEXDesc"
        ,aDesc:"男"
        ,aClassName:"User.CTSex"
    }, false);
    obj.SexVLng = $m({          //当前页(默认最后一页)
        ClassName: "DHCHAI.Abstract",
        MethodName: "HAIGetTranByDesc",
        aProp: "CTSEXDesc"
        ,aDesc:"女"
        ,aClassName:"User.CTSex"
    }, false);
    obj.cboSex = $HUI.combobox("#cboSex", {
		editable: true,
		allowNull: true, 
		valueField: 'value',
		textField: 'text',
		data: [
			{ value: 'M', text: obj.SexNLng },
			{ value: 'F', text: obj.SexVLng }
        ]
	});
    //初始化下拉菜单2->[所在科室]
    var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	var HospIDs=HospList.rows[0].ID;	//取全部院区
	var LocType=$m({ 
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "ExpStaffLocType"
	}, false);
	if (LocType=="E"){
    	obj.cboExpLoc=Common_ComboToLoc("cboExpLoc", HospIDs, "", "", "OELocType","1");
	}
    else{
    	obj.cboExpLoc=Common_ComboToLoc("cboExpLoc", HospIDs, "", "", "OWLocType","1");
    }
    //定义数组(默认2~10)
    obj.SumID=2;
    obj.Sum = new Array();
	obj.Sum[2]="二",obj.Sum[3]="三",obj.Sum[4]="四",obj.Sum[5]="五",obj.Sum[6]="六";
	obj.Sum[7]="七",obj.Sum[8]="八",obj.Sum[9]="九",obj.Sum[10]="十",obj.Sum[11]="十一"; 	
	
    //加载页签1:登记报告
    var ExtTypeIDs_1= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        aExtTypeID:1,
        rows:999
    }, false);
		//获取弹窗方式 0为窗口 1为csp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
	},false);
	var width="1283px"
	if(obj.flg=="0"){
	 width="auto"
	}
	//获取暴露信息
	obj._RegTypeData = $cm({				
		ClassName: "DHCHAI.IRS.OccExpTypeSrv",
		QueryName: "QryOccExpType",
		aActive:"1",
		aRegTypeID: RegTypeID
	}, false);
	obj.RegTypeDesc=obj._RegTypeData.rows[0].BTDesc;
    var html_1=""
    for (var ind = 0; ind < ExtTypeIDs_1.total; ind++) {
        var ExtTypeData = ExtTypeIDs_1.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var TypeCode = ExtTypeData.TypeCode;
        var TypeDesc = ExtTypeData.TypeDesc;
        //DIV(名称为DIV-1)
        html_1 = html_1	+"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"、"+TypeDesc + "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\" style='width:"+width+";padding:5px'>"
                      	+"	<div id='DIV" + TypeID + "' style='margin:0px 10px 0px 10px;'></div>"
	                  	+"</div>";
	    obj.SumID++;
    }
    $('#OccInfo_1').html(html_1);
    $.parser.parse('#OccInfo_1'); 		// 解析页签1
    //加载页签2:审核观察
    var ExtTypeIDs_2= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        aExtTypeID:2,
        rows:999
    }, false);
    var html_2=""
    for (var ind = 0; ind < ExtTypeIDs_2.total; ind++) {
        var ExtTypeData = ExtTypeIDs_2.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var TypeCode = ExtTypeData.TypeCode;
        var TypeDesc = ExtTypeData.TypeDesc;
        if(ind==ExtTypeIDs_2.total-1){
	    	html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"、追踪检测" + "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='LabDIV' style='margin:0px 10px 0px 10px;'>123456</div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
	    }
        //DIV(名称为DIV-1)
        html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"、" + TypeDesc + "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='DIV" + TypeID + "' style='margin:0px 10px 0px 10px;'></div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
    }
    //特殊情况(未配置审核观察内容)只显示检验
    if(ExtTypeIDs_2.total==0){
		html_2 = html_2 +"<div class='hisui-panel' data-options=\"title:'" +obj.Sum[obj.SumID]+"、追踪检测" + "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\" style='width:1280px;padding:0px 5px 5px 5px;'>"
                      	+"		<div id='LabDIV' style='margin:0px 10px 0px 10px;padding-top:5px;'>123456</div>"
        				+"</div>"
        				+"<div style='padding-bottom:10px;'></div>";
      	obj.SumID++;
	}
    $('#OccInfo_2').html(html_2)
    $.parser.parse('#OccInfo_2'); 		// 解析页签2
    
    //加载页签[架构]:构建框架(详细见文档)
     var ExtTypeIDs= $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryExpRegType",
        aRegTypeID: RegTypeID,
        rows:999
    }, false);
	for (var ind = 0; ind < ExtTypeIDs.total;ind++) {
        var ExtTypeData = ExtTypeIDs.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;
        var Data = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
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
		    	//var SLine=SLine='<span class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
		    }
            
            var html 	= 	'<div id="Box'+BoxID+'" style="padding-top:8px;padding-bottom:4px;">'
                    	+ 	'	<div id="Box'+BoxID+'-1"></div>'	//主框架[XX01XX]
                    	+	'	<div style="clear:both;"></div>'	//清除浮动
                        + 	'	<div id="Box'+BoxID+'-2""></div>'	//扩充框架[XX0101]
                      	+ 	'</div>'
                       	+ 	SLine;
           	$("#DIV" + TypeID).append(html);
	    }
    }
    //加载页签[内容]:填充内容(详细见文档)--工龄、年龄....
    for (var ind = 0; ind < ExtTypeIDs.total; ind++) {
        var ExtTypeData = ExtTypeIDs.rows[ind];
        
        var TypeID = ExtTypeData.TypeID;	//暴露信息、暴露源信息
        var Data = $cm({
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
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
         	Label=$g(Label);  //多语言改造
	     	//(1):文字描述
	     	if (DataType == "") {   	
       			var html='<div id="'+ItemID+'"><b>' + Label + '</b></div>'
           		
				// if(Label.indexOf("职业史")>-1||Label.indexOf("职业接触的情况")>-1){
				// 	html+='<a style="padding-left:50px;" id="btn-add" href="#" class="easyui-linkbutton" data-options="iconCls:'+"icon-Add"+'" onclick="obj.Add('+"'"+Label+"'"+')">新增</a>';
				// 	html+='<a style="padding-left:50px;"id="btn-del" href="#" class="easyui-linkbutton" data-options="iconCls:'+"icon-remove"+'" onclick="obj.del('+"'"+Label+"'"+')">删除</a>';
					
				// }
				$("#Box"+BoxID).append(html);
       		}
            //(2):单选字典
	      	else if (DataType == "DS") {  //单选字典
             	var html 	= 	'<div id="div_'+ ItemID + '">'
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
            	var html 	= 	'<div id="div_'+ ItemID + '">'
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
	           	if(Code=="050130"){
		        	var html=	'<div style="float:left;width:50%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 430px;" />'
							+	'</div>';
		        }
		        else{
			    	var html=	'<div id="div_'+ ItemID + '" style="float:left;width:25%;">'
							+	'	<span style="width:100px;padding-right:10px;text-align:right;display:inline-block;"><b>' + Label + '</b></span>'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 180px;" />'
							+	'</div>';
			    }
            	
				
            	$("#Box"+BoxID).append(html);   
        	}
          	if (DataType == "TB") {   //长文本	
            	var html=	'<div style="padding-left:5px;">'
							+ 	'	<input class="textbox" id="' + ItemID + '" style="width: 1060px;" placeholder="' + Label + '..."/>'
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
                //加载单选列表(默认2列)
                //Common_RadioToDic(ItemID, DicCode, 2); 
                Common_RadioTextToDic(ItemID, DicCode, 2,1); 
				debugger
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
    //加载检验结果
    var Html 	="<div style='padding-left:50px;padding-top:5px;'><input id='chkHBV' type='checkbox' class='hisui-checkbox' label='HBV' name='chkLab' value='HBV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    			+"<input id='chkHCV' type='checkbox' class='hisui-checkbox' label='HCV' name='chkLab' value='HCV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
    			+"<input id='chkHIV' type='checkbox' class='hisui-checkbox' label='HIV' name='chkLab' value='HIV'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
    if(obj.RegTypeDesc.indexOf("血源性")<0){
		var Html=Html+"<input id='chkMD' type='checkbox' class='hisui-checkbox' label='梅毒' name='chkLab' value='MD'></div>";
	}

    var Html=Html+'<span id="LineLab" class="line" style="display: block; border-bottom: 1px solid #ccc;margin: 1px 0;border-bottom-style:dashed;clear:both;"></span>';
    var Html=Html+"<div id='LabData'><table class='report-tab'>";
    var LabList = $cm({
        ClassName: "DHCHAI.IRS.OccExpTypeSrv",
        QueryName: "QryOccExpTypeLab",
        aTypeID: RegTypeID,
		aIsActive:1,
		rows:999
    }, false);
    for (var i = 0; i < LabList.total; i++) {
        var LabData = LabList.rows[i];
        var ID = LabData.ID;
        var BTDesc = LabData.BTDesc;
        var BTDays = LabData.BTDays;
        var Resume = LabData.Resume;
        var SubID = ID.split("||")[1];
		var LabType=LabData.LabType;
		
        var Html = Html + '	<tr id="'+LabType+"_"+SubID+'" class="report-tr">'
                        + '		<td style="padding-left:50px;">' + BTDesc + '</td>'
                        + '		<td class="report-td">' + Resume + '</td>'
                        + '		<td class="report-td">检验日期</td>'
                        + '		<td><input class="hisui-datebox textbox" id="dtLabDate' + SubID + '" style="width: 200px; " /></td>'
                        + '		<td class="report-td">检验项目</td>'
                        + '		<td><input class="textbox" id="txtLabItem' + SubID + '" style="width: 200px; " /></td>'
                        + '		<td class="report-td">检验结果</td>'
                        //下拉框
                        + '		<td><input class="textbox" id="cboLabResult' + SubID + '" style="width: 200px; " /></td>'
                        //文本框
                        //+ '		<td><input class="textbox" id="cboLabResult' + SubID + '" style="width: 200px; " /></td>'
                        + '	</tr>';
    }
    var Html = Html + '</table></div>';
    
    $('#LabDIV').html(Html);
    $.parser.parse('#LabDIV');
    //下拉框加载
    for (var i = 0; i < LabList.total; i++) {
        var LabData = LabList.rows[i];
        var ID = LabData.ID;
        var SubID = ID.split("||")[1];
        
        $HUI.combobox("#cboLabResult"+SubID, {
			editable: true,
			allowNull: true, 
			valueField: 'value',
			textField: 'text',
			data: [
				{ value: '1', text: '阴性' },
				{ value: '2', text: '阳性' },
				{ value: '3', text: '不详' }
        	]
		});
    }
    $('#LabData').hide();	//默认隐藏
    $('#LineLab').hide();	//默认隐藏
    $('.line').css("padding-bottom","5px");
    
    InitFloatWin();			//加载帮助页面
    InitReportWinEvent(obj);
    obj.LoadEvent();
    return obj;
}