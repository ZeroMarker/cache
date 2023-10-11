function InitPARepWinEvent(obj){
	//保存PDCA报告
	//1、保存'基本信息'
	obj.SaveBase=function(SatusID,Type){
		var ItemType = $('#cboItemType').val();				//项目类型
		var ItemName = $("#txtItemName").val();				//项目名称
		var Index = $('#cboIndex').combobox('getValue');	//指标类型
		var RegDate  ="";
		var RegTime  ="";
		var RegLocID =(Type=="1")?$.LOGON.LOCID:obj.PARepData.split("^")[7];
		var RegUserID=(Type=="1")?$.LOGON.USERID:obj.PARepData.split("^")[9];
		var TargetVal =$('#txtTargetVal').val();			//目标值
		var ModTypeID =	RegTypeID;							//模板ID
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
		var InputStr_Base=InputStr_Base+CHR_1+SatusID;
		var InputStr_Base=InputStr_Base+CHR_1+TargetVal;
		var InputStr_Base=InputStr_Base+CHR_1+ModTypeID;
        return InputStr_Base;
	}
	//2、保存'扩展信息'
	obj.SaveExt=function(SatusID){
		var InputStr_Ext="";
		
		//暂时写死
		var DateFrom=$("#020110").datebox('getValue');	
		var DateTo=$("#020120").datebox('getValue');	
		if (DateFrom>DateTo) {
            $.messager.alert("提示", "事件分析开始日期不能大于事件分析结束日期！", 'info');
            return false;
        }
		
    	//输出'扩展信息'
    	var DataList= $cm ({
			ClassName:"DHCHAI.IRS.PDCAModSrv",
			QueryName:"QryPDCAExpTypeExt",
			aRegID:obj.RegID,
			rows: 999
		},false);
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
		return InputStr_Ext;
	}
	//3.保存科室信息
	//Module_Loc
	//4.保存日志信息
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
	//5.保存PDCA报告
	obj.Save=function(SatusID,SaveType){
		//1.保存基本信息
		var InputStr_Base=obj.SaveBase(SatusID,SaveType);
		if(!InputStr_Base)return false;
		//2.保存扩展信息
		var InputStr_Exts=obj.SaveExt(SatusID);	
		if(!InputStr_Exts)return false;
		//3.保存科室信息
		if(SaveType=="1")var InputStr_Locs=obj.SaveLocP(SatusID);
		if(SaveType=="2")var InputStr_Locs=obj.SaveLocD(SatusID);
		if(SaveType=="3")var InputStr_Locs=obj.SaveLocCA(SatusID);
		if(!InputStr_Locs)return false;
		//4.保存日志信息
		var InputStr_Log=obj.SaveLog(SatusID);
		if(!InputStr_Log)return false;
		
	 	var Flag = $m({
			ClassName: "DHCHAI.IRS.PDCARepSrv",
            MethodName: "SavePAReport",
            aPARep:InputStr_Base,
            aPARepExts:InputStr_Exts,
            aPARepLocs:InputStr_Locs,
            aPARepLog:InputStr_Log,
            aSaveType:SaveType
        }, false);
		if (parseInt(Flag) > 0) {
            obj.RepID = parseInt(Flag);
           
           	obj.LoadBase();		//加载基本信息
			obj.LoadExt();		//加载扩展信息
			obj.initLocData();	//加载科室信息
			
			//刷新按钮
			obj.InitButtons();
		
            return true;
		}
		else{
            return false;
		}
	}
	//加载PDCA报告
	//1、加载'基本信息'
	obj.LoadBase=function(){
		if(obj.RepID!=""){
			obj.PARepData = $m({
           		ClassName: "DHCHAI.IRS.PDCARepSrv",
           		MethodName: "GetPARep",
           		aRepID: obj.RepID
        	}, false);
        	$('#cboItemType').lookup("setText",obj.PARepData.split("^")[0]);					//项目类型
			$("#txtItemName").val(obj.PARepData.split("^")[1]);									//项目名称
        	$('#cboIndex').combobox('setValue',obj.PARepData.split("^")[2]);					//关联指标
			$('#cboIndex').combobox('setText',obj.PARepData.split("^")[3])
        	$("#txtTargetVal").val(obj.PARepData.split("^")[4]);								//目标值
        	$("#txtRegDateTime").val(obj.PARepData.split("^")[5]+" "+obj.PARepData.split("^")[6]);	//登记日期时间
        	$("#txtRegLoc").val(obj.PARepData.split("^")[8]);									//登记科室
        	$("#txtRegUser").val(obj.PARepData.split("^")[10]);									//登记人
        	//$('#txtStatus').val(obj.PARepData.split("^")[13]);									//报告状态
        	//科室
    		var SubLocList= $cm({
				ClassName: "DHCHAI.IRS.PDCARepSrv",
				QueryName: "QryPARepLoc",
				aRepID: obj.RepID,
				aIsHist:"0",
				aSubID:SubID,
				rows: 999
			}, false);
        	$('#txtStatus').val(SubLocList.rows[0].Status);			
        	
        	obj.RepStatusCode=obj.PARepData.split("^")[12];
        	
        	obj.RepName=obj.PARepData.split("^")[14];											//报表名称
        	$('#txtRepName').html(obj.RepName);
    		obj.RepCsp=obj.PARepData.split("^")[15];											//关联csp
		}
	}
	//2、加载'扩展信息'
	obj.LoadExt=function(){
		//输出'扩展信息'
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
	}
	//3.加载科室信息
	//obj.initLocData();
	
	//初始化事件
	obj.LoadEvent=function(){
		obj.LoadBase();		//加载基本信息
		obj.LoadExt();		//加载扩展信息
		obj.initLocData();	//加载科室信息
		
		//刷新按钮
		obj.InitButtons();
		
		//是否启用'文件上传'
		if(obj.IsOpenUpLoad!="1")$('.UpLoad').hide();			
		
		//鼠标滑过'+'
		$("#btnAddPlanLoc").mouseover(function() {
			$("#btnAddPlanLoc").css("background", "#dbedf9");
		});
		//鼠标划出'+'
		$("#btnAddPlanLoc").mouseout(function() {
			$("#btnAddPlanLoc").css("background", "white");
		});
		//鼠标点击'+'
		$('#btnAddPlanLoc').click(function (e) {
			obj.LocIndexList[obj.LocIndexID]=parseInt(obj.IndexVal)+1;
			obj.LocSubList[obj.LocIndexID]="";
			obj.LocIndexID++;
			obj.IndexVal++;
			
			obj.AddPlanHtml(obj.IndexVal);
		})	
		//隐藏'+'
		if((obj.RepStatusCode!="1")&&(obj.RepStatusCode!="")){
			$('#Line_P_'+obj.IndexVal).hide();
			$('#PlanAddDiv').hide();
		}
		
		//绑定'历史科室记录'
		$(".icon-clock-record").on('click',function(){
    		obj.InitHistLoc();
		});
		//绑定'切换页签D'
		$HUI.tabs("#DoTabs", {
			onSelect: function (title,index){
				obj.LocSubID=obj.PARepLocList.rows[index].ID;	//记录选中'科室表'
			}
		});
		//绑定'切换页签CA'
		$HUI.tabs("#CATabs", {
			onSelect: function (title,index){
				obj.LocSubID=obj.PARepLocList.rows[index].ID;	//记录选中'科室表'
			}
		});
		//隐藏文件上传
		obj.IsUpLoad = $m({	
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "PDCAUseUpLoad"
		}, false);
		if (obj.IsUpLoad=="1"){
			$('.UpLoad').show();
		}
		else{
			$('.UpLoad').hide();
		}
	}
	//->刷新按钮
	obj.InitButtons = function () {
		//隐藏'删除'
		if((obj.RepStatusCode!="1")&&(obj.RepStatusCode!="3")&&(obj.RepStatusCode!="")){
			$('.icon-cancel').hide();
		}
		else{
			$('.icon-cancel').show();
		}
		
		//默认隐藏页签
        tab_option = $('#Maintabs').tabs('getTab', "登记计划").panel('options').tab;
        tab_option.hide();
        tab_option = $('#Maintabs').tabs('getTab', "执行").panel('options').tab;
        tab_option.hide();
        tab_option = $('#Maintabs').tabs('getTab', "检查评价").panel('options').tab;
        tab_option.hide();
        $('.tabs-wrap').height(0);
        $('.tabs').height(0);
        
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
		//C-A:检查评价
		$('#btnCheck_A').hide();	//审核
		
        switch (obj.RepStatusCode) {
	        //P->暂存
            case "1":							
            	$('#btnSave_P').show();
                $('#btnSubmit_P').show();
                $('#btnDelete_P').show();
                //$('#btnExport_P').show();
                break;
            //P->提交并审核
            case "2":								
                $('#btnUnCheck_P').show();
                $('#btnDelete_P').show();
                //$('#btnExport_P').show();
                
                $('#btnSave_D').show();	
				$('#btnSubmit_D').show();
				
				//加载页签
				if(obj.Admin!="1"){
                	//默认加载'Do'页签
                	$("#Maintabs").tabs('select', 1);
				}
                break;
            //P->取消审核
           	case "3":							
                $('#btnSave_P').show();
                $('#btnSubmit_P').show();
                $('#btnDelete_P').show();
                //$('#btnExport_P').show();
                break;
            //P->删除
           	case "4":	
                break;
            //D->暂存
            case "6":	
				if(obj.Admin!="1"){
	            	$('#btnSave_D').show();	
					$('#btnSubmit_D').show();
					//默认加载'Do'页签
                	$("#Maintabs").tabs('select', 1);
	            }
                break;
            //D->提交
            case "7":		
            	//启用'护士长/科主任'签字
            	if(obj.IsPDCASign=="1"){		//1.护士长
	            	if(obj.SupNurFlg=="1"){
		            	$('#btnSuperNur_D').show();
		            }
		            if(obj.SupDocFlg=="1"){		//2.科主任
			        	$('#btnSuperDor_D').show();
			        }
			        //加载页签
	           		if(obj.Admin!="1"){
	           			//默认加载'Do'页签
                		$("#Maintabs").tabs('select', 1);
                    	
                    	$('#btnSubmit_D').show();
		        	}
	            }
	            else{
		        	$('#btnCheck_A').show();
		        	//加载页签
	           		if(obj.Admin=="1"){
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
	           		else{
		           		$('#btnSubmit_D').show();
                    	//默认加载'Do'页签
                   	 	$("#Maintabs").tabs('select', 1);
		        	}
		        }
                break;
            //D->护士长签字
            case "8":
            	$('#btnCheck_A').show();
		        //加载页签
	           	if(obj.Admin=="1"){
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
	           	else{
		           	$('#btnSubmit_D').show();
                    //默认加载'Do'页签
                   	 $("#Maintabs").tabs('select', 1);
		        }
				
            	break;
           	//D->科主任签字
            case "9":
            	$('#btnCheck_A').show();
		         //加载页签
	           	if(obj.Admin=="1"){
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
	           	else{
		           	$('#btnSubmit_D').show();
                    //默认加载'Do'页签
                   	$("#Maintabs").tabs('select', 1);
		        }
				
            	break;
			case "10":
				$('#btnCheck_A').show();
				
				//加载页签
				if(obj.Admin=="1"){
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
				else{
					//默认加载'Do'页签
                    $("#Maintabs").tabs('select', 1);
				}
                break;
            default:
               	$('#btnSave_P').show();
                $('#btnSubmit_P').show();
                break;
        }
    }
    //->点击'P-保存'按钮
	$('#btnSave_P').click(function (e) {
		var Flag=obj.Save(1,1);
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
    //->点击'P-提交'按钮
	$('#btnSubmit_P').click(function (e) {
		var Flag=obj.Save(2,1);
		if(Flag){
			$.messager.alert("提示", "提交成功！", 'info');
			
			//按钮事件
        	obj.RepStatusCode = "2";
        	obj.InitButtons();
		}
		else{
	    	$.messager.alert("提示", "提交失败！", 'info');
            return false;
	    }
    });
    //->点击'P-取消审核'按钮
	$('#btnUnCheck_P').click(function (e) {
		var Flag=obj.Save(3,1);
		if(Flag){
			$.messager.alert("提示", "取消审核成功！", 'info');
			
        	//按钮事件
         	obj.RepStatusCode = "3";
       	 	obj.InitButtons();
		}
		else{
	    	$.messager.alert("提示", "取消审核失败！", 'info');
            return false;
	    }
    });
    //->点击'P-删除'按钮
	$('#btnDelete_P').click(function (e) {
		$.messager.confirm("提示", '是否删除该报告?', function (r) {
			if (r) {
	        	var Flag=obj.Save(4,1);
				if(Flag){
					$.messager.alert("提示", "删除成功！", 'info');
					
        			//按钮事件
        			obj.RepStatusCode = "4";
        			obj.InitButtons();
				}
				else{
	    			$.messager.alert("提示", "删除失败！", 'info');
            		return false;
	   		 	}		
			}
		});
    });
    //->点击'D-保存'按钮
	$('#btnSave_D').click(function (e) {
		var Flag=obj.Save(6,2);
        if(Flag){
	        $.messager.alert("提示", "保存成功！", 'info');
	        
  	      	//按钮事件
    	    obj.RepStatusCode = "6";
        	obj.InitButtons();
        }
        else{
	    	$.messager.alert("提示", "保存失败！", 'info');
            return false;
		}	
    });
    //->点击'D-提交'按钮
	$('#btnSubmit_D').click(function (e) {
		var Flag=obj.Save(7,2);
		if(Flag){
			$.messager.alert("提示", "提交成功！", 'info');
			
			//按钮事件
        	obj.RepStatusCode = "7";
        	obj.InitButtons();
		}
		else{
	    	$.messager.alert("提示", "提交失败！", 'info');
            return false;
		}	
    });
    //->点击'D-护士长审核'按钮
	$('#btnSuperNur_D').click(function (e) {
		$.messager.alert("提示", "护士长审核成功！", 'info');
		
		var Flag=obj.Save(8,2);
        if(Flag){
        	//按钮事件
        	obj.RepStatusCode = "8";
        	obj.InitButtons();
        }
        else{
	    	$.messager.alert("提示", "护士长审核失败！", 'info');
            return false;
		}	
    });
    //->点击'D-科主任审核'按钮
	$('#btnSuperDor_D').click(function (e) {
		var Flag=obj.Save(9,2);
        if(Flag){
	        $.messager.alert("提示", "科主任审核成功！", 'info');
	        
        	//按钮事件
        	obj.RepStatusCode = "9";
        	obj.InitButtons();
        }
        else{
	    	$.messager.alert("提示", "科主任审核失败！", 'info');
            return false;
		}	
    });
    //->点击'CA-保存'按钮
	$('#btnCheck_A').click(function (e) {
		var AssessVal=$('#cboAssess_1').combobox('getText');	
		if(AssessVal==""){
			$.messager.alert("提示", "效果评价不能为空！", 'info');
            return false;
		}
		if(AssessVal!="完成改进"){
		 	$.messager.confirm("提示", '该科室未完成整改，是否需要科室继续整改?', function (r) {
            	if (r) {
	            	var Flag=obj.Save(2,3);
	            	if(Flag){
	            		//置为历史记录
	            		var Flag = $m({
							ClassName: "DHCHAI.IR.PDCARepLoc",
							MethodName: "SetIsHist",
							aID: obj.RepID+"||"+obj.LocSubID,
							aIsHist:1
						}, false);
	            	
	            		obj.RepStatusCode = "2";
	            		//按钮事件
        				obj.InitButtons();
        				//切换页签
        				$("#Maintabs").tabs('select', 0);
        				
        				$.messager.alert("提示", "审核成功！", 'info');
        				return;
	            	}	
            	}
            	else {
	            	var Flag=obj.Save(10,3);	
	            	if(Flag){
        				obj.RepStatusCode = "10";
        				//按钮事件
        				obj.InitButtons();
        				
        				$.messager.alert("提示", "审核成功！", 'info');
                		return;
	            	}
            	}
            });
		}
		else{
			var Flag=obj.Save(10,3);
			if(Flag){
				$.messager.alert("提示", "审核成功！", 'info');
            
				obj.RepStatusCode = "10";
        		//按钮事件
        		obj.InitButtons();	
			}	
		}
    });
	
	//->刷新历史科室评估
	obj.InitHistLoc=function(){
		obj.gridHistPDCA = $HUI.datagrid("#gridHistPDCA",{
			fit: true,
			iconCls:"icon-resort",
			headerCls:'panel-header-gray',
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: false, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			//nowrap: true, fitColumns: true,     //自动填充整个页面
			loadMsg:'数据加载中...',
			url:$URL,
			queryParams:{
			    ClassName: "DHCHAI.IRS.PDCARegSrv",
		    	QueryName: "QryPARepList",
		    	aLocID:obj.Admin=="1"?"":$.LOGON.LOCID,
		   	 	aUserID:"",
		   	 	aIsHist:"1",
		   	 	aRepID:obj.RepID
			},
			columns:[[
				{ field: 'RepID', title: 'ID', width: 50, align: 'center' },
				{ field: 'ItemType', title: '项目类型', width: 210, align: 'center' },
				{ field: 'ItemDesc', title: '项目名称', width: 220, align: 'center' },
				{ field: 'IndexDesc', title: '指标名称', width: 220, align: 'center' },
            	{ field: 'RegDate', title: '登记日期', width: 120, align: 'center' },
            	{ field: 'PlanLocDesc', title: '整改科室', width: 150, align: 'center' },
				{ field: 'PlanAdminUserDesc', title: '院感科责任人', width: 150, align: 'center' },
            	{ field: 'PlanLocUserDesc', title: '整改科室责任人', width: 150, align: 'center' },
            	{ field: 'AssessDesc', title: '效果评价', width: 120, align: 'center' },
			]],
			onDblClickRow: function (rowIndex, rowData) {
				if(rowIndex>-1){
			   	 	var aRegTypeID = rowData.RegTypeID;
			    	var aReportID = rowData.ID;

			    	obj.OpenOccView(aRegTypeID, 1, obj.AdminPower,obj.StatusDesc);   //打开职业暴露报告
				}
			},
        	onLoadSuccess: function (data) {
	        	if (data.total > 0) {
	        		dispalyEasyUILoad(); 			//隐藏效果
             		//合并单元格实现表格样式
	    	 		$(this).datagrid("autoMergeCellAndCells", ['RepID','ItemType','ItemDesc','IndexDesc','RegDate']);    	//合并行
            	}
        	}	
		});	
		$('#LayerOpenHistPDCA').show();
		$HUI.dialog('#LayerOpenHistPDCA',{
			title:"操作记录", 
			iconCls:'icon-resort',
			width: 1200,    
			height: 500, 
			modal: true,
			isTopZindex:true
		});
		//极简版-修正边框色值
		if (HISUIStyleCode=="lite"){
 			$('#LayerOpenHistPDCA .panel-body.panel-body-noheader').css("border-color","#E2E2E2");
 		}
		
	}
	//2.点击相关	
	
	
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
	
	
	
