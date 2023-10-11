//'PDCA报告'基本内容
var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var obj = new Object();
function InitPARepBaseWin() {
	obj.RegID=RegTypeID;		//模板ID
	obj.RepID=ReportID;			//报告ID
	obj.SubID=SubID;			//报告扩展(科室)表ID
	obj.Admin=AdminPower;		//管理员权限(院感科权限)
	obj.RepStatusCode="";		//报告状态
	
	var GroupDesc = session['LOGON.GROUPDESC'];
	obj.SupNurFlg =0;			//护士长标记
	if(GroupDesc.indexOf('护士长')>-1)obj.SupNurFlg=0;	
	obj.SupDocFlg =0;			//科主任标记	
	if(GroupDesc.indexOf('主任')>-1)obj.SupDocFlg=0;	
	
	//'PDCA报告'-编辑框+文件框
	InitPARepLoadWin(obj);
	//'PDCA报告'-科室
	InitPARepLocWin(obj);

	//初始化'基本信息'
	//->1.项目类型
	$("#cboItemType").lookup({
		panelWidth:220,
		url:$URL,
		editable: true,
		mode:'remote',
		valueField: 'ID',
		textField: 'ItemType',
		queryParams:{
			ClassName: 'DHCHAI.IRS.PDCARepSrv',
			QueryName: 'QryPAItemType'
		},
		columns:[[  
			{field:'ID',title:'ID',width:50},
			{field:'ItemType',title:'类型',width:140}			
		]],
		onBeforeLoad:function(param){
			var desc=param['q']; 
			param = $.extend(param,{aItemType:desc}); 	//将参数q转换为类中的参数
		},
		pagination:true,
		showPageList:false, showRefresh:false,displayMsg:'',
		loadMsg:'正在查询',
		isCombo:true,            		 				//是否输入字符即触发事件，进行搜索
		minQueryLen:1             						//isCombo为true时，可以搜索要求的字符最小长度
	});
	//->2.指标名称
	var IndexList = $cm ({
		ClassName:"DHCHAI.IRS.PDCAIndexBaseSrv",
		QueryName:"QryPDCAIndexBase",
		aIsActive:1
	},false);
	$HUI.combobox("#cboIndex",{
		valueField:'ID',
		textField:'IndexDesc',
		editable:false,
		data:IndexList.rows
	});
	//初始化'扩展信息'(默认 问题聚焦+现状分析)
	//->定义显示数组(默认2~10)
    obj.TitleID=2;
    obj.TitleList = new Array();
	obj.TitleList[2]="二",obj.TitleList[3]="三",obj.TitleList[4]="四",obj.TitleList[5]="五",obj.TitleList[6]="六";
	obj.TitleList[7]="七",obj.TitleList[8]="八",obj.TitleList[9]="九",obj.TitleList[10]="十",obj.TitleList[11]="十一"; 
	//->定义 文件框+编辑框
	obj.FileID=1;
	obj.EditID=1;
    obj.FileList = new Array();
    obj.EditList = new Array();
	//1.根据'模板'构造'扩展内容'
	var ExtList= $cm ({
		ClassName:"DHCHAI.IRS.PDCAModSrv",
		QueryName:"QryPDCAExpType",
		aRegID:obj.RegID
	},false);
	var Html="";
    for (var xInd = 0; xInd < ExtList.total; xInd++) {
        var ExtInfo = ExtList.rows[xInd];
        
		var TypeID 		= ExtInfo.DicID;		//ID(1068)
        var TypeCode 	= ExtInfo.DicCode;		//Code(1)
        var TypeDesc	= ExtInfo.DicDesc;		//Desc(问题聚焦)
        
        //构建DIV(问题聚焦)
        Html= Html+"<div style='padding:7px 0px 5px 0px;'class='hisui-panel' data-options=\"title:'" +obj.TitleList[obj.TitleID]+"、"+TypeDesc+ "(标注为*的项目为必填项)',headerCls:'panel-header-gray'\">";
		var DataList= $cm ({
			ClassName:"DHCHAI.IRS.PDCAModSrv",
			QueryName:"QryPDCAExpTypeExt",
			aRegID:obj.RegID,
			aTypeID:TypeID
		},false);
		for (var yInd = 0; yInd < DataList.total; yInd++) {
        	var DataInfo = DataList.rows[yInd];
        
			var ID 		= DataInfo.ID;			//ID(1||7)
        	var Code 	= DataInfo.Code;		//Code(010200)
        	var Desc	= DataInfo.Desc;		//Desc(问题聚焦-描述)
			
			var DataType= DataInfo.DatCode; 
			if (DataType == "F") { 				//文件框
				Html= Html+'<div style="padding-left:10px;">'
					+'	<div class="UpLoad"><input class="" type="file" id="'+Code+'" name="uploadify"/><span id="'+Code+'_arg"></span></div>'
					+'</div>';
					//存储ID
					obj.FileList[obj.FileID]=Code;
					obj.FileID++;
			}
			if (DataType == "ED") { 			//编辑框
				Html= Html+'<div style="clear:both;"></div>';	//清除浮动
				Html= Html+'<div">'
					+'	<script type="text/plain" id="'+Code+'" style="border:1px solid #d4d4d4;"></script>'
					+'</div>';
					//存储ID
					obj.EditList[obj.EditID]=Code;
					obj.EditID++;
			}
			if (DataType == "DD") { 			//日期框
				Html= Html+'<div style="float:left;width:25%;">'
					+'	<span style="width:120px;padding:5px 5px 5px 10px;text-align:right;display:inline-block;">' + Desc + ':</span>'
					+'	<input class=\'hisui-datebox textbox\' id="' + Code + '"style="width:167px;"/>'
					+'</div>'; 
			}	
		}	
		Html= Html+"</div>";
	    obj.TitleID++;
    }
	$('#ExtDiv').html(Html);
    $.parser.parse('#ExtDiv');
    //->初始化 扩展信息
    for(ind=1;ind<=obj.FileList.length;ind++){		//文件框
		var ID=obj.FileList[ind];
		obj.InitUpLoad(ID);
	}
    for(ind=1;ind<=obj.EditList.length;ind++){		//编辑框
		var ID=obj.EditList[ind];
		obj.InitEditor(ID,"1260","150");
	}
    //->调整编辑框边距
	$('#ExtDiv .edui-container').css('padding','5px 10px 5px 10px');
	
	//初始化流程P->D->C->A
	//->获取整改科室信息
	obj.LocList = $cm({
		ClassName:"DHCHAI.IRS.PDCARepSrvTMP",
		QueryName:"QryPARepLoc",
		aRepID: obj.RepID,
		rows: 999
	}, false);
	//初始化'Plan'
	obj.InitPlanHtml();
	//初始化'Do'
	obj.InitDoHtml();
	//初始化'C+A'
	obj.InitCAHtml();
	
	//加载'报告内容'
	obj.LoadRep=function(){
		if((obj.RepID!="")&&(obj.SubID!="")){
			//->加载基本信息
			obj.RepData = $m({
           		ClassName: "DHCHAI.IRS.PDCARepSrv",
           		MethodName: "GetPARep",
           		aRepID: obj.RepID
        	}, false);
			$('#cboItemType').lookup("setText",obj.RepData.split("^")[0]);	//项目类型
			$("#txtItemName").val(obj.RepData.split("^")[1]);				//项目名称
        	$('#cboIndex').combobox('setValue',obj.RepData.split("^")[2]);	//关联指标
			$('#cboIndex').combobox('setText',obj.RepData.split("^")[3])
        	$("#txtTargetVal").val(obj.RepData.split("^")[4]);				//目标值
        	$("#txtRegDateTime").val(obj.RepData.split("^")[5]+" "+obj.RepData.split("^")[6]);		//登记日期时间
        	$("#txtRegLoc").val(obj.RepData.split("^")[8]);					//登记科室
        	$("#txtRegUser").val(obj.RepData.split("^")[10]);				//登记人
        	
        	obj.RepName=obj.RepData.split("^")[14];							//关联报表
    		obj.RepCsp=obj.RepData.split("^")[15];							//关联csp
    		//—>加载扩展报告内容
    		var RepExtList = $cm({
		 		ClassName: "DHCHAI.IRS.PDCARepSrv",
            	QueryName: "QryPARepExt",
            	aRepID: obj.RepID,
            	rows: 999
       	 	}, false);
			for (var Ind = 0; Ind < RepExtList.total; Ind++) {
        		var RepExtInfo = RepExtList.rows[Ind];
        	
        		var ItemCode=RepExtInfo.ItemCode;	//Code(010200)
           		var Value=RepExtInfo.ResultTxt;		//Value
           		//转换特殊字符
        		Value=obj.GetEditorData(Value,"2");
        	
        		var ItemType = RepExtInfo.DatCode;
        		if (ItemType == "ED")UM.getEditor(ItemCode).setContent(Value,false);	//编辑框
				if (ItemType == "DD")$("#"+ItemCode).datebox('setValue',Value);			//日期框
    		}
    		//加载P-D-C-A报告内容
    		obj.LocList = $cm({
				ClassName:"DHCHAI.IRS.PDCARepSrvTMP",
				QueryName:"QryPARepLoc",
				aRepID: obj.RepID,
				rows: 999
			}, false);
    		obj.LoadPDCA();
		}
	}
	//初始化事件
	obj.LoadEvent=function(){
		obj.LoadRep();		//加载报告内容
		obj.InitButtons();	//刷新按钮
		//处理页签格式问题
    	$('.tabs-panels').css("border","0px")
		//是否启用'文件上传'
		if(obj.IsOpenUpLoad!="1")$('.UpLoad').hide();	
		//新增整改计划
		$('#btnAddPlanLoc').click(function (e) {
			obj.PLList[obj.PLID]=obj.PLID+1;
			
			obj.AddPlanHtml(obj.PLList[obj.PLID]);
			obj.PLID++;
		})	
		//切换页签
    	$HUI.tabs("#CATabs", {
			onSelect: function (title,index){
				obj.SubID=obj.PLList[index]
			}
		});
	}
    //保存1:基本信息+扩展信息+整改科室
    obj.SaveBase=function(SatusID){
	    //->基本信息
		var ItemType 	= $('#cboItemType').val();				//项目类型
		var ItemName 	= $("#txtItemName").val();				//项目名称
		var Index 		= $('#cboIndex').combobox('getValue');	//指标类型
		var RegDate  	= "";
		var RegTime  	= "";
		var RegLocID 	= $.LOGON.LOCID;
		var RegUserID	= $.LOGON.USERID;
		var TargetVal 	= $('#txtTargetVal').val();				//目标值
		var ModTypeID 	= RegTypeID;							//模板ID
		if (ItemType=="") {
            $.messager.alert("提示", "项目类型不能为空！", 'info');
            return false;
        }
        if (ItemName=="") {
            $.messager.alert("提示", "项目名称不能为空！", 'info');
            return false;
        }
         if (Index=="") {
            $.messager.alert("提示", "指标名称不能为空！", 'info');
            return false;
        }
        if (TargetVal=="") {
            $.messager.alert("提示", "目标值不能为空！", 'info');
            return false;
        }
		var InputStr_Base=obj.RepID;
		var InputStr_Base=InputStr_Base+CHR_1+ItemType;
		var InputStr_Base=InputStr_Base+CHR_1+ItemName;
		var InputStr_Base=InputStr_Base+CHR_1+Index;
		var InputStr_Base=InputStr_Base+CHR_1+RegDate;
		var InputStr_Base=InputStr_Base+CHR_1+RegTime;
		var InputStr_Base=InputStr_Base+CHR_1+RegLocID;
		var InputStr_Base=InputStr_Base+CHR_1+RegUserID;
		var InputStr_Base=InputStr_Base+CHR_1+TargetVal;
		var InputStr_Base=InputStr_Base+CHR_1+ModTypeID;
        //->扩展信息(**暂时写死**)
        var DateFrom=$("#020110").datebox('getValue');	
		var DateTo=$("#020120").datebox('getValue');	
		if (DateFrom>DateTo) {
            $.messager.alert("提示", "事件分析开始日期不能大于事件分析结束日期！", 'info');
            return false;
        }
       
		var DataList= $cm ({
			ClassName:"DHCHAI.IRS.PDCAModSrv",
			QueryName:"QryPDCAExpTypeExt",
			aRegID:obj.RegID,
			rows: 999
		},false);
		var InputStr_Ext="";
		for (var Ind = 0; Ind < DataList.total; Ind++) {
        	var DataInfo = DataList.rows[Ind];
        	
        	var ItemID 		= DataInfo.ID;			//ID(1||7)
        	var ItemCode 	= DataInfo.Code;		//Code(010200)
        	var ItemDesc 	= DataInfo.Desc;		//Desc(问题聚焦-描述)
            var ItemType 	= DataInfo.DatCode;
        	if(ItemType=="F")continue;				//'文件框单独存储数据'
        	//获取'PDCA报告表'->扩展表ID
        	var ChildSub = $m({
				ClassName: "DHCHAI.IR.PDCARepExt",
				MethodName: "GetIDByItemDr",
				aReportID: obj.RepID,
				aItemDr: ItemID
			}, false);
        	var Value="";
			if (ItemType == "ED")Value=UM.getEditor(ItemCode).getContent();		//编辑框
			if (ItemType == "DD")Value=$("#"+ItemCode).datebox('getValue');		//日期框
			//转换特殊字符
        	Value=obj.GetEditorData(Value,"1");
        	
        	var InputStr_Ext=InputStr_Ext+CHR_2;
			var InputStr_Ext=InputStr_Ext+CHR_1+ChildSub;
			var InputStr_Ext=InputStr_Ext+CHR_1+ItemID;
			var InputStr_Ext=InputStr_Ext+CHR_1+ItemDesc;
			var InputStr_Ext=InputStr_Ext+CHR_1+ItemType;
			var InputStr_Ext=InputStr_Ext+CHR_1+"";
			var InputStr_Ext=InputStr_Ext+CHR_1+"";
			var InputStr_Ext=InputStr_Ext+CHR_1+Value;
			var InputStr_Ext=InputStr_Ext+CHR_1+"";
			var InputStr_Ext=InputStr_Ext+CHR_1+"";
			var InputStr_Ext=InputStr_Ext+CHR_1+$.LOGON.USERID;
    	}
        //->整改科室
        var InputStr_LocP=obj.SavePlan(SatusID);
        //->日志信息
        var InputStr_Log=obj.SaveLog(SatusID);
        
        var Flag = $m({
			ClassName: "DHCHAI.IRS.PDCARepSrvTMP",
            MethodName: "SavePDCARep",
            aRepInfo:InputStr_Base,
            aRepExtInfo:InputStr_Ext,
            aRepLocInfo:InputStr_LocP,
            aRepLog:InputStr_Log
        }, false);
		if (parseInt(Flag) > 0) {
           	ReportID	=parseInt(Flag);
            obj.RepID 	= parseInt(Flag);
           	obj.LoadRep();
           	
            return true;
		}
		else{
            return false;
		}
	}	
	//保存4.日志信息
	obj.SaveLog=function(SatusID){
		var Update  ="";
		var Uptime  ="";
		var UpUserID =$.LOGON.USERID;
		var InputStr_Log="";
		var InputStr_Log=InputStr_Log+CHR_1+"";
		var InputStr_Log=InputStr_Log+CHR_1+SatusID;
		var InputStr_Log=InputStr_Log+CHR_1+Update;
		var InputStr_Log=InputStr_Log+CHR_1+Uptime;
		var InputStr_Log=InputStr_Log+CHR_1+UpUserID;
		
        return InputStr_Log;
	}
	//按钮点击事假	
	//->Plan:点击'保存'按钮
	$('#btnSave_P').click(function (e) {
		var Flag=obj.SaveBase("1");
		if(Flag){
			$.messager.alert("提示", "保存成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "1";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "保存失败！", 'info');
            return false;
	    }
    });
    //->Plan:点击'审核'按钮
	$('#btnSubmit_P').click(function (e) {
		var Flag=obj.SaveBase("2");
		if(Flag){
			$.messager.alert("提示", "审核成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "2";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "审核失败！", 'info');
            return false;
	    }
    });
    //->Plan:点击'取消审核'按钮
	$('#btnUnCheck_P').click(function (e) {
		var Flag=obj.SaveBase("3");
		if(Flag){
			$.messager.alert("提示", "取消审核成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "3";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "取消审核失败！", 'info');
            return false;
	    }
    });
    //->Plan:点击'删除'按钮
	$('#btnDelete_P').click(function (e) {
		$.messager.confirm("提示", '是否删除该报告?', function (r) {
			if (r) {
	        	var Flag=obj.SaveBase("4");
				if(Flag){
					$.messager.alert("提示", "删除成功！", 'info');
        			//按钮事件
        			obj.RepStatusCode = "4";
        			obj.InitButtons()
        	
           		 	return false;
        		}
        		else{
	    			$.messager.alert("提示", "删除失败！", 'info');
            		return false;
	    		}	
			}
		});
    });
    //->Plan:点击'导出'按钮
	$('#btnExport_P').click(function (e) {
		$.messager.alert("提示", "暂未开放该功能！", 'info');
        return false;
    });
    //->Do:点击'暂存'按钮
	$('#btnSave_D').click(function (e) {
		var Flag=obj.SaveDo("6");
		if(Flag){
			$.messager.alert("提示", "暂存成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "6";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "暂存失败！", 'info');
            return false;
	    }
    });
    //->Do:点击'提交'按钮
	$('#btnSubmit_D').click(function (e) {
		var Flag=obj.SaveDo("7");
		if(Flag){
			$.messager.alert("提示", "提交成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "7";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "提交失败！", 'info');
            return false;
	    }
    });
    //->Do:点击'护士长签字'按钮
	$('#btnSuperNur_D').click(function (e) {
		var Flag=obj.SaveDo("8");
		if(Flag){
			$.messager.alert("提示", "护士长签字成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "8";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "护士长签字失败！", 'info');
            return false;
	    }
    });
    //->Do:点击'科主任签字'按钮
	$('#btnSuperDor_D').click(function (e) {
		var Flag=obj.SaveDo("9");
		if(Flag){
			$.messager.alert("提示", "科主任签字成功！", 'info');
        	//按钮事件
        	obj.RepStatusCode = "9";
        	obj.InitButtons()
        	
            return false;
        }
        else{
	    	$.messager.alert("提示", "科主任签字失败！", 'info');
            return false;
	    }
    });
    //->CA:点击'审核'按钮
	$('#btnCheck_A').click(function (e) {
		var Assess=$('#cboAssess_'+obj.SubID).combobox('getText');		//效果评价
		if(Assess==""){
			$.messager.alert("提示", "效果评价不能为空！", 'info');
            return false;
		}
		var Flag=obj.SaveCA("10");
		if(Flag){
			/*
			if(Assess!="完成改进"){
				$.messager.confirm("提示", '该科室未完成整改，是否需要科室继续整改?', function (r) {
            		if (r) {
	            		var Flag = $m({
							ClassName: "DHCHAI.IR.PDCARepLoc",
							MethodName: "SetIsActive",
							aID: obj.RepID+"||"+obj.SubID,
							aIsActive:0
						}, false);
	            		obj.SubID=parseInt(Flag)	//更新子表ID
	            		
        				$.messager.alert("提示", "审核成功！", 'info');
        				//按钮事件
        				obj.RepStatusCode = "2";
        				obj.InitButtons()
	            	}	
	            	else {
        				//按钮事件
	            		obj.RepStatusCode = "10";
        				obj.InitButtons();
        				
        				$.messager.alert("提示", "审核成功！", 'info');
	            	}
            	});
        	}
       	 	else{
	    		$.messager.alert("提示", "审核成功！", 'info');
            	return true;
	   	 	}*/
	   	 	//按钮事件
	        obj.RepStatusCode = "10";
        	obj.InitButtons();
        				
        	$.messager.alert("提示", "审核成功！", 'info');
		}
		else{
	    	$.messager.alert("提示", "审核失败！", 'info');
			return false;
	   	}
	});
	//->刷新按钮
	obj.InitButtons = function () {
		//默认隐藏按钮
		$('#btnSave_P').hide();	
		$('#btnSubmit_P').hide();
		$('#btnUnCheck_P').hide();
		$('#btnDelete_P').hide();	
		$('#btnExport_P').hide();
		$('#btnSave_D').hide();	
		$('#btnSubmit_D').hide();
		$('#btnSuperNur_D').hide();	
		$('#btnSuperDor_D').hide();	
		//默认隐藏页签
        tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
        tab_option.hide();
        tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
        tab_option.hide();
        tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
        tab_option.hide();
        
        $('.tabs-wrap').height(0);
        $('.tabs').height(0);
        //默认隐藏
        $('.icon-cancel').hide();
        $('#PlanAddDiv').hide();
        
		if (obj.Admin=="1"){
			//隐藏-选中科室页签
			for(ind=0;ind<obj.LocList.total;ind++){
				var LocInfo = obj.LocList.rows[ind];
        		var ID=LocInfo.ID;
        		
        		if(ID==obj.SubID){
	        		$("#DoTabs").tabs('select',ind);
	        		$("#CATabs").tabs('select',ind);
	        	}
		        if(LocInfo.StatusCode<"7"){
			    	tab_option = $('#DoTabs').tabs('getTab',LocInfo.PLocDesc).panel('options').tab;
               		tab_option.hide();
               		tab_option = $('#CATabs').tabs('getTab',LocInfo.PLocDesc).panel('options').tab;
               		tab_option.hide();
				}
	        }
        	
			switch (obj.RepStatusCode) {
				//P->暂存
            	case "1":							
            		$('#btnSave_P').show();
               	 	$('#btnSubmit_P').show();
                	$('#btnDelete_P').show();
                	//$('#btnExport_P').show();
                	
                	$('.icon-cancel').show();
        			$('#PlanAddDiv').show();
                	break;
            	//P->提交并审核
            	case "2":								
                	$('#btnUnCheck_P').show();
                	$('#btnDelete_P').show();
                	//$('#btnExport_P').show();
               	break;
            	//P->取消审核
           		case "3":							
                	$('#btnSave_P').show();
                	$('#btnSubmit_P').show();
                	$('#btnDelete_P').show();
                	//$('#btnExport_P').show();
                	
                	$('.icon-cancel').show();
        			$('#PlanAddDiv').show();
               	 	break;
            	//P->删除
           		case "4":	
               	 	break;
                //D->提交
            	case "7":		
            		//不启用'护士长/科主任'签字
            		if(obj.IsPDCASign!="1"){
	            		$('#btnCheck_A').show();
		        		//加载页签
		        		tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
               			tab_option.show();
                    	tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
                    	tab_option.show();
                    	tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
                    	tab_option.show();
                    	//默认加载'CA'页签
                    	$("#Maintabs").tabs('select', 2);
                    	
                    	$('.tabs').height(35);
						$('.tabs-wrap').height(35);
	           		}
                	break;
            	//D->护士长签字
            	case "8":
            		$('#btnCheck_A').show();
		        	//加载页签
		        	tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
               		tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
                    tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
                    tab_option.show();
                    //默认加载'CA'页签
                    $("#Maintabs").tabs('select', 2);
                    	
                    $('.tabs').height(35);
					$('.tabs-wrap').height(35);
            		break;
           		//D->科主任签字
            	case "9":
            		$('#btnCheck_A').show();
		        	//加载页签
		        	tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
               		tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
                    tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
                    tab_option.show();
                    //默认加载'CA'页签
                    $("#Maintabs").tabs('select', 2);
                    	
                    $('.tabs').height(35);
					$('.tabs-wrap').height(35);
            		break;
				case "10":
					$('#btnCheck_A').show();
		        	//加载页签
		        	tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
               		tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
                    tab_option.show();
                    tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
                    tab_option.show();
                    //默认加载'CA'页签
                    $("#Maintabs").tabs('select', 2);
                    	
                    $('.tabs').height(35);
					$('.tabs-wrap').height(35);
            		break;
            	default:
               	 	$('#btnSave_P').show();
               	 	$('#btnSubmit_P').show();
                	$('#btnDelete_P').show();
                	//$('#btnExport_P').show();
                	
                	$('.icon-cancel').show();
        			$('#PlanAddDiv').show();
                	break;					
            }
		}
		else{
			//默认加载'Do'页签
			$("#Maintabs").tabs('select', 1);
			//隐藏-选中科室页签
			for(ind=0;ind<obj.LocList.total;ind++){
				var LocInfo = obj.LocList.rows[ind];
        		var ID=LocInfo.ID;
        		
        		tab_option = $('#DoTabs').tabs('getTab',LocInfo.PLocDesc).panel('options').tab;
               	tab_option.hide();
               	
        		if(ID==obj.SubID){
	        		$("#DoTabs").tabs('select',ind);
	        	}
	        }
	        $('.tabs-wrap').height(0);
        	$('.tabs').height(0);
			
			switch (obj.RepStatusCode) {
				 //P->审核
            	case "2":	
					$('#btnSave_D').show();	
					$('#btnSubmit_D').show();
                	break;
				//D->暂存
            	case "6":	
					$('#btnSave_D').show();	
					$('#btnSubmit_D').show();
                	break;
                //D->提交
            	case "7":		
					$('#btnSubmit_D').show();
            		//启用'护士长/科主任'签字
            		if(obj.IsPDCASign=="1"){
	            		if(obj.SupNurFlg=="1"){
		            		$('#btnSuperNur_D').show();	//1.护士长
		            	}
		            	if(obj.SupDocFlg=="1"){		
			        		$('#btnSuperDor_D').show();	//2.科主任
			        	}	
	           		}
                	break;
            	//D->护士长签字
            	case "8":
            		$('#btnSuperNur_D').show();
            		break;
           		//D->科主任签字
            	case "9":
            		$('#btnSuperDor_D').show();
            		break;
            	default:
               	 	break;						
            }
		}
    }		
	
	//->处理编辑框数据格式
	obj.GetEditorData=function(Data,Type){
		if(!Data)return "";
		if(Type=="1"){
			//保存
			var reg = new RegExp("\"","g");
			Data=Data.replace(reg,"CH1");
			var reg = new RegExp(" ","g");
			Data=Data.replace(reg,"CH2");
		}
		if(Type=="2"){
			//输出
			var reg = new RegExp("CH1","g");
			Data=Data.replace(reg,"\"");
			var reg = new RegExp("CH2","g");
			Data=Data.replace(reg," ");
		}
		return Data;
	}	
 
    //InitFloatWin();				//加载帮助页面
    
   	obj.LoadEvent();
    return obj;
}
