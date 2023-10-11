//页面Gui
var objScreen = new Object();
function InitEnviHyApplyWin(){
	var obj = objScreen;
	obj.Report ='';
	obj.HospData = '';
	LogonHospID=$.LOGON.HOSPID;
	LogonHospDesc=$.LOGON.HOSPDESC;
	LogonUserID=$.LOGON.USERID;
	LogonLocID=$.LOGON.LOCID;
	LogonLocDesc=$.LOGON.LOCDESC;
	var DateID=""
	$.parser.parse(); // 解析EasyUI组件
  	//状态列表
	obj.StatusOrder = ServerObj.StatusList;
	obj.IsValidReason = ServerObj.IsValidReason;
	//找采集标本的前一状态
	obj.BeforeStatusCode="";
    StatusOrderArr=obj.StatusOrder.split(',');
	var StatusLength = StatusOrderArr.length;
    for(var i = 0;i < StatusLength;i++){
	    if (StatusOrderArr[i]=="") continue;
        if(StatusOrderArr[i].split('^')[0] == "6"){
            obj.BeforeStatusCode=StatusOrderArr[i-1].split('^')[0];
            break
        }
    }

    //查询条件
	if (tDHCMedMenuOper['Admin']!=1) {  //临床科室
	    obj.cboHospital = Common_ComboToSSHosp("cboHospital",LogonHospID);
	    obj.cboMonitorLoc = Common_ComboToLoc('cboMonitorLoc',LogonHospID);	
	    $('#cboHospital').combobox('disable');
	    $('#cboMonitorLoc').combobox('disable');
		$('#cboHospital').combobox('setValue',LogonHospID);
		$('#cboMonitorLoc').combobox('setValue',LogonLocID);
		$('#cboMonitorLoc').combobox('setText',LogonLocDesc);
		obj.AdminFlag=0;
		obj.MonitorLoc=$("#cboMonitorLoc").combobox('getValue');
	}else {
		obj.AdminFlag = tDHCMedMenuOper['Admin'];
		obj.MonitorLoc="";
		var HospList = $cm ({
			ClassName:"DHCHAI.BTS.HospitalSrv",
			QueryName:"QryHospListByLogon",
			aLogonHospID:$.LOGON.HOSPID
		},false);
		obj.HospData = HospList.rows;
		
		$HUI.combobox("#cboHospital",{
			valueField:'ID',
			textField:'HospDesc',
			editable:false,
			data:obj.HospData,
			onSelect:function(rec){
				Common_ComboToLoc('cboMonitorLoc',rec.ID);
			},onLoadSuccess:function(data){
				// 院区默认选择
				$('#cboHospital').combobox('select',data[0].ID);
			}
		});
		$('#cboMonitorLoc').combobox({}); //联动表格需先初始化
		$('#cboHospital').combobox('enable');
	    $('#cboMonitorLoc').combobox('enable');
	}
	
	//默认日期类型
	$HUI.combobox("#DateType",{
		data:[{Id:'MonitorDate',text:$g('监测日期'),selected:true},{Id:'ApplyDate',text:$g('申请日期')}],
		valueField:'Id',
		textField:'text'
	})
	
	//设置开始日期为当月1号
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date);
	var DateTo=Common_GetDate(new Date());
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',DateTo);
	//监测项目
	$HUI.combobox("#cboEvItem", {
		valueField:'ID',
		defaultFilter:4,
		textField:'ItemDesc',
		onShowPanel: function () {
			if (tDHCMedMenuOper['Admin']=="1"){
				var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+$('#cboEvItemFL').combobox('getValue');
			}else{
				var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+$('#cboMonitorLoc').combobox('getValue')+"&aEvItemFL="+$('#cboEvItemFL').combobox('getValue');
			}
			$("#cboEvItem").combobox('reload',url);
		}
	});
	var cboEvItemFLList = $cm ({
		ClassName:"DHCHAI.BTS.DictionarySrv",
		QueryName:"QryDic",
		aTypeCode:"EHItemType"
	},false);
	obj.EvItemFL = cboEvItemFLList.rows;
	$HUI.combobox("#cboEvItemFL",{
		valueField:'ID',
		defaultFilter:4,
		textField:'DicDesc',
		editable:false,
		data:obj.EvItemFL,
		onSelect:function(rec){
			//Common_ComboToLoc('cboMonitorLoc',rec.ID);
			$HUI.combobox("#cboEvItem", {
				valueField:'ID',
				textField:'ItemDesc',
				onShowPanel: function () {
					//var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&aIsActive=1&ResultSetType=Array&EvItemFL="+rec.ID;
					if (tDHCMedMenuOper['Admin']=="1"){
						var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+""+"&aEvItemFL="+rec.ID;
					}else{
						var url=$URL+"?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID="+$('#cboMonitorLoc').combobox('getValue')+"&aEvItemFL="+rec.ID;
					}
					$("#cboEvItem").combobox('reload',url);
				}
			});
		},onLoadSuccess:function(data){
			// 院区默认选择
			//Common_ComboDicID('cboItemType','EHItemType');
			//$('#cboEvItemFL').combobox('select',data[0].ID);
		}
	});
	//报告状态
	obj.cboRepStatus = Common_ComboDicCode("cboRepStatus","EHRepStatus");	
      
    //表格
	obj.gridApply = $('#gridApply').datagrid({
        fit:true,
        title:'申请列表',
        toolbar:'#custtb',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        striped:true,
        sortName:'',
        sortOrder:'desc',
        singleSelect:false,
        selectOnCheck:true,
        checkOnSelect:true,
        fitColumns:false,
        loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
	        QueryName:'QryEvReport',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aDateType:$("#DateType").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aMonitorLoc:$("#cboMonitorLoc").combobox('getValue'),
	        aItemID:$("#cboEvItem").combobox('getValue'),
	        aStatusCode:$("#cboRepStatus").combobox('getValue'),
	        aFlowFlg:'',
	        aStandard:Common_RadioValue('checkStandard')
	    },
	    frozenColumns:[[{ field:'checked',checkbox:'true',align:'center',width:30}]],
        columns:[[
	        { field:"BarCode",title:"申请号",sortable:true,
	        	formatter:function(value,row,index){
		        	if (row.ReCheckSign == '1'){
						return '┏' + value+"&nbsp";
					} else if (row.ReCheckSign == '2'){
						return '┃' + value+"&nbsp";
					} else if (row.ReCheckSign == '3'){
						return '┗' + value+"&nbsp";
					} else {
						return value;
					}
		        }
	        ,width:125},
			{ field:"EvItemDesc",title:"监测项目",width:180,sortable:true},	
			{ field:"ApplyDate",title:"申请日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepStatusDesc",title:"状态",width:80,sortable:true},
			{ field:"EvItemObjDesc",title:"监测对象",width:80,sortable:true},
			{ field:"MonitorLocDesc",title:"监测科室",width:100,sortable:true},
			{ field:"MonitorDate",title:"监测日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"SpenTypeDesc",title:"标本类型",width:80,sortable:true},
			{ field:"SpecimenNum",title:"标本数量",width:80,sortable:true},
			{ field:"Result",title:"监测结果",align:'center',width:80,sortable:true,
				formatter:function(value,row,index){
					 return '<a href="#" onclick=objScreen.ShowResutlDtl(\''+row.ReportID+'\','+index+')><span class="icon icon-eye" style="width:20px;display:inline-block;">&nbsp;</span>'+$g("查看")+'</a>';
				}
			},
			{ field:"StandardDesc",title:"是否合格",width:80,sortable:true,
				styler: function(value,row,index){
					if (value==$g("不合格")){
						return 'background-color:#FFEDEB;color:#FF1414;';
					}else if (value==$g("合格")){
						return 'background-color:#F8FFF3;color:#229A06;';
					}else{
						return 'background-color:#ECECEC;color:#000000;';
					}
				},
				formatter:function(value,row,index){
					if (value=="") (value="无结果")
					value=$g(value);  //多语言翻译
		        	if (row.ReCheckSign == '1'){
						return  value;
					} else if (row.ReCheckSign == '2'){
						return value;
					} else if (row.ReCheckSign == '3'){
						return  value;
					} else {
						return value;
					}
		        }
			},		
			{ field:"ReCheck",title:"复检",width:80,sortable:true,
				formatter:function(value,row,index){
					if (row.StandardDesc=="不合格") {
					 	if (row.IsChecked=="1") {
							if ((obj.IsValidReason==1)&&(!!row.Reason)) {
								return '<a id="tt1" href="#" onClick="objScreen.ReCheck('+row.ReportID+')" title="不合格原因:'+row.Reason+"\n改进措施:"+row.Action+'" class="hisui-tooltip" data-options="position:\'right\'">'+$g("已复检")+'</a>'
							}else{
								return $g("已复检")
							}
					 	}else{
						 	return '<a href="#" onclick=objScreen.ReCheck('+row.ReportID+')><span class="icon icon-reset" style="width:20px;display:inline-block;">&nbsp;</span>'+$g("复检")+'</a>';
						}
					}else {
						if (row.ReCheckRepID>0) {
							if((obj.IsValidReason==1)&&(!!row.Reason)){
								return '<a id="tt1" href="#" title="不合格原因:'+row.Reason+"\n改进措施:"+row.Action+'" class="hisui-tooltip" data-options="position:\'right\'">'+$g("复检单")+'</a>'
							}else {
								return $g("复检单")
							}
						}else{
							return 	''
						}
					}
				}
			},
			{ field:"SampleResult",title:"参照点结果",width:180,sortable:true},
			{field:'EnterTypeDesc',title:'录入方式',width:155,sortable:true},
			{ field:"ApplyLocDesc",title:"申请科室",width:120,sortable:true},
			{ field:"ApplyUserDesc",title:"申请人",width:100,sortable:true},
			{field:'Reason',title:'不合格原因',width:'80',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true},
			{field:'Action',title:'改进措施',width:'80',sortable:true,showTip:true,tipWidth:200,tipTrackMouse:true}
        ]]
        ,rowStyler: function(index,row){
			if (row.ReCheckRepID>0){
				return 'background-color:#b2ebf2;'; 
			}
		}
        ,onBeforeLoad:function(param){
	        var StatusCode 	= $("#cboRepStatus").combobox('getValue');
	        if (obj.StatusOrder.indexOf('6')>-1) {
		    	$('#btnColSpec').show();
		    	if (StatusCode==obj.BeforeStatusCode) {
			    	$("#btnColSpec").linkbutton("enable"); //查询状态为发放材料且有采集标本操作时，显示采集按钮
		    	}else {
		    		$("#btnColSpec").linkbutton("disable");
		    	}
		    }else{
			    $('#btnColSpec').hide();
			}
        },
        onSelect:function(rowIndex, rowData){
	        if (ServerObj.StatusList.indexOf('6')>-1) {
			    if (rowData.RepStatusCode==obj.BeforeStatusCode){
	       			$("#btnColSpec").linkbutton("enable");
			    }
	        }
        },
        onUnselect:function(rowIndex, rowData){
	        $("#btnColSpec").linkbutton("disable");
	        var StatusCode 	= $("#cboRepStatus").combobox('getValue');
	        if ((StatusCode!='2')&&(ServerObj.StatusList.indexOf('6')>-1)) {
		        var chkRows=$('#gridApply').datagrid('getChecked');
				for (var row = 0; row < chkRows.length; row++){
					var rd = chkRows[row];
					var RepStatusCode = rd['RepStatusCode'];
					if (RepStatusCode !=obj.BeforeStatusCode) continue;
					$("#btnColSpec").linkbutton("enable");
				}
	        }
        },
		onDblClickRow:function(rowIndex,rowData){
			$("#gridApply").datagrid('clearSelections');  //取消历史选中	
			obj.Report=rowData;
			if ((tDHCMedMenuOper['Admin']!=1)&&(rowData.MonitorLocID!=LogonLocID)) {
				$.messager.popover({msg: '临床科室只能查看本科室申请',type:'error',timeout: 2000});
				return;	
			}
			obj.ApplyEdit();		
        }
	});
	if (obj.IsValidReason!=1){
		 $("#gridApply").datagrid("hideColumn", "Reason");        //如果非必选,隐藏最后两列
		  $("#gridApply").datagrid("hideColumn", "Action");    
	}
	/*申请单监测结果明细*/
	$('#ResultDetail').dialog({
		title: '监测结果',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true
	});
	
	obj.ApplyEdit = function(){
		//初始化
		$('#addA').show();	
		obj.execute =0;  //执行
		$('#cboAHospital').combobox('enable');
		$('#cboALoc').combobox('enable');
		$('#cboAEvItem').combobox('enable');
		$('#cboAEvObject').combobox('enable');
		websys_enable('txtCenterNum');
		websys_enable('txtSurroundNum');
		websys_enable('txtReferToNum');
		websys_enable('AEvObjectTxt');	
		if (tDHCMedMenuOper['Admin']=="1"){
			var ALocDr="";
		}else{
			var ALocDr=$('#cboALoc').combobox('getValue');
		}				
		$HUI.combobox("#cboAEvItem",{
			//url:$URL+'?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array&aIsActive=1&aLocID='+$('#cboALoc').combobox('getValue'),
			url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID='+ALocDr,
			valueField:'ID',
			textField:'ItemDesc',
			defaultFilter:4,
			allowNull: true, 
			onSelect:function(row){
				var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
				$('#AEvIsObjNull',IsObjNull);
				if (obj.execute==1) return;
				obj.LoadEvObjectSpen(row.ID);
			},onChange:function(newvalue,oldvalue){
				obj.LoadEvObjectSpen(newvalue);
			}
		});
		//add by 2021-01-18
		$HUI.combobox("#cboaddAEvObject",{
			url:$URL+'?ClassName=DHCHAI.IRS.EnviHyObjectSrv&QueryName=QryEvObjectByLoc&ResultSetType=Array&aLocDr='+$('#cboALoc').combobox('getValue'),
			valueField:'ID',
			textField:'ObjectDesc',
			allowNull: true
		});		
		// add by zhoubo	
		$HUI.combobox("#cboALoc",{
			onChange:function(newvalue,oldvalue){
				if (tDHCMedMenuOper['Admin']=="1"){
					var ALocDr="";
				}else{
					var ALocDr=$('#cboALoc').combobox('getValue');
				}
				$HUI.combobox("#cboAEvItem",{
					//url:$URL+'?ClassName=DHCHAI.IRS.EnviHyItemSrv&QueryName=QryEvItem&ResultSetType=Array&aLocID='+$('#cboALoc').combobox('getValue'),
					url:$URL+'?ClassName=DHCHAI.IRS.EnviHyLocItemsSrv&QueryName=QryLocItems&ResultSetType=Array&aLocID='+ALocDr,
					valueField:'ID',
					textField:'ItemDesc',
					allowNull: true, 
					onSelect:function(row){
						var IsObjNull = row.IsObjNull;	//获取对象是否允许为空
						$('#AEvIsObjNull',IsObjNull);
						if (obj.execute==1) return;
						obj.LoadEvObjectSpen(row.ID);
					},onChange:function(newvalue,oldvalue){
						obj.LoadEvObjectSpen(newvalue);
					},onLoadSuccess:function(){
						//obj.LoadEvObjectSpen();
					}
				});
				$HUI.combobox("#cboaddAEvObject",{
					url:$URL+'?ClassName=DHCHAI.IRS.EnviHyObjectSrv&QueryName=QryEvObjectByLoc&ResultSetType=Array&aLocDr='+$('#cboALoc').combobox('getValue'),
					valueField:'ID',
					textField:'ObjectDesc',
					allowNull: true
				});
				obj.LoadEvObjectSpen("");
			}
		});				
		if (obj.Report) {   //加载数据
			if (obj.Report.RepStatusDesc!="申请") {
				$('#addA').hide();				
				websys_disable('txtCenterNum');
				websys_disable('txtSurroundNum');
				websys_disable('txtReferToNum');
			}
			if (obj.Report.ReCheckRepID>0) {    //复检
				$('#cboAHospital').combobox('disable');
				$('#cboALoc').combobox('disable');
				$('#cboAEvItem').combobox('disable');
				$('#cboAEvObject').combobox('disable');
				websys_disable('AEvObjectTxt');
				websys_disable('txtCenterNum');
				websys_disable('txtSurroundNum');
				websys_disable('txtReferToNum');
			}
			var HospList = $cm({
				ClassName:"DHCHAI.BTS.HospitalSrv",
				QueryName:"QryHospListByLogon",
				aLogonHospID:$.LOGON.HOSPID
			},false);
			obj.HospData = HospList.rows;
			$HUI.combobox("#cboAHospital",{
				valueField:'ID',
				textField:'HospDesc',
				editable:false,
				data:obj.HospData,
				onSelect:function(rec){
					Common_ComboToLoc('cboALoc',rec.ID);
				},onLoadSuccess:function(data){
					$('#cboAHospital').combobox('select',obj.Report.HospID);
				}
			});
			$('#cboALoc').combobox('setValue',obj.Report.MonitorLocID);
			$('#cboALoc').combobox('setText',obj.Report.MonitorLocDesc);
			$('#AMonitorDate').datebox('setValue',obj.Report.MonitorDate);
			$('#cboAEvItem').combobox('setValue',obj.Report.EvItemID);
			$('#cboAEvItem').combobox('setText',obj.Report.EvItemDesc);
			$('#cboAEvObject').combobox('setValue',obj.Report.EvItemObjID);	
			$('#cboAEvObject').combobox('setText',obj.Report.EvItemObjDesc.split("[")[0]);	
			$('#AEvObjectTxt').val(obj.Report.EHItemObjTxt);
			$('#txtCenterNum').val(obj.Report.RepCenterNum);
			$('#txtSurroundNum').val(obj.Report.RepSurroundNum);
			$('#txtReferToNum').val(obj.Report.ReferToNum);	
			$("#AEvIsObjNull").val(obj.Report.IsObjNull);
			if (tDHCMedMenuOper['Admin']!=1){
				$('#cboAHospital').combobox('disable');
				$('#cboALoc').combobox('disable');
			}

		}else {   //初始化
			if (tDHCMedMenuOper['Admin']!=1){ //非管理员，新建本科室申请
				obj.cboAHospital = Common_ComboToSSHosp("cboAHospital",LogonHospID);
		   		obj.cboALoc = Common_ComboToLoc('cboALoc',LogonHospID);	
			    $('#cboAHospital').combobox('disable');
			    $('#cboALoc').combobox('disable');
				$('#cboAHospital').combobox('setValue',LogonHospID);
				//取登录人的院区翻译
				obj.LogonHospDescLng = $m({          //当前页(默认最后一页)
			        ClassName: "DHCHAI.Abstract",
			        MethodName: "HAIGetTranByDesc",
			        aProp: "HOSPDesc"
			        ,aDesc:LogonHospDesc
			        ,aClassName:"User.CTHospital"
			    }, false);
				$('#cboAHospital').combobox('setText',obj.LogonHospDescLng);
				$('#cboALoc').combobox('setValue',LogonLocID);
				$('#cboALoc').combobox('setText',LogonLocDesc);							
			}else { 			//如果是管理员新建申请，科室与查询处监测科室一致
		    	$HUI.combobox("#cboAHospital",{
					valueField:'ID',
					textField:'HospDesc',
					editable:false,
					data:obj.HospData,
					onSelect:function(rec){
						Common_ComboToLoc('cboALoc',rec.ID);
					},onLoadSuccess:function(data){
						// 院区默认选择
						$('#cboAHospital').combobox('select',data[0].ID);
					}
				});
				$('#cboALoc').combobox({}); //联动表格需先初始化
				$('#cboALoc').combobox('setValue',LogonLocID);
				$('#cboALoc').combobox('setText',LogonLocDesc);	
				
				//$('#cboALoc').combobox('setValue',$('#cboMonitorLoc').combobox('getValue'));
				$('#cboAHospital').combobox('enable');
		    	$('#cboALoc').combobox('enable');					
			}
			
			var AMonitorDate=Common_GetDate(new Date());
			$('#AMonitorDate').datebox('setValue',AMonitorDate);
			$('#cboAEvItem').combobox('setValue','');
			$('#cboAEvObject').combobox('setValue','');
			$('#txtCenterNum').val('');
			$('#txtSurroundNum').val('');
			$('#AEvObjectTxt').val('');
			$('#txtReferToNum').val('');
		}
		
		
		//申请单编辑modal
		$('#ApplyEdit').dialog({
			title: '监测申请单',
			iconCls:"icon-w-paper",
			headerCls:'panel-header-gray',
			modal: true
		});
		$HUI.dialog('#ApplyEdit').open();
		$(".datebox .validatebox-text").css("width","262px")
	}
	
	obj.LoadEvObjectSpen = function(EvItemID){
		obj.execute =1;  //执行
		var EvObjectdata=$cm({
			ClassName:'DHCHAI.IRS.EnviHyItemSrv',
			QueryName:'QryEvObjsByItem',
			ResultSetType:'array',
			aParRef:EvItemID,
			aLocID:$('#cboALoc').combobox('getValue')	
		},false);

		$HUI.combobox("#cboAEvObject",{
			data:EvObjectdata,
			valueField:'ObjID',
			textField:'ObjDesc',
			editable:true,
			onLoadSuccess:function(data){
				//只有一条记录默认加载
				if (data.length==1) {
					$('#cboAEvObject').combobox('select',data[0]['ObjID']);
				}
			}
		});
	
		var SpenNum = $m({
			ClassName:'DHCHAI.IR.EnviHyItem',
			MethodName:'GetSpenNumById',
			Id:EvItemID
		},false)
		var SpenNumArr=SpenNum.split("^");
		var CenterNum=SpenNumArr[1];
		var SurroundNum=SpenNumArr[2];
		var ReferToNum=SpenNumArr[3];
		var EHIsSpecNum=SpenNumArr[4];
		$('#txtCenterNum').val(CenterNum);
		$('#txtSurroundNum').val(SurroundNum);
		$('#txtReferToNum').val(ReferToNum);	
	
		if (EHIsSpecNum==0) { //如果不允许调整标本数量，则禁用录入框
			websys_disable('txtCenterNum');
			websys_disable('txtSurroundNum');
			websys_disable('txtReferToNum');
		}					

	}
	
	//复制历史申请单modal
	$('#CopyApply').dialog({
		title:'复制历史申请单',
		iconCls:"icon-w-paper",
		closed: true,
		closeable: true,
		modal: true,
		onBeforeOpen:function(){
			DateID=""
			//初始化科室下拉列表
			var CAMonitorLoc = $cm ({
				ClassName:"DHCHAI.BTS.LocationSrv",
				QueryName:"QryLoc",
				aHospIDs:$("#cboHospital").combobox('getValue'),
				rows:1000,
				aAlias:"",
				aLocCate:"",
				aLocType :"",
				aIsActive:"1"
			},false);
			obj.CAMonitorLocList = CAMonitorLoc.rows;
			if(DateID!=""){
				$HUI.combobox("#CAMonitorLoc",{
					valueField:'ID',
					textField:'LocDesc2',
					editable:true,
					data:obj.CAMonitorLocList,
					onSelect:function(rec){//给医院增加Select事件，更新科室列表
						$('#HisApplyList').datagrid('load',{
				 	 		ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				        	QueryName:'QryEvReportByMonth',
				        	aHospIDs:$("#cboHospital").combobox('getValue'),
				        	aMonth:DateID,
				        	aDate:$('#CAMonitorDate').datebox('getValue'),
				        	aMonitorLoc:$("#CAMonitorLoc").combobox('getValue')
						});
					}
					
				});
			}else{
					$HUI.combobox("#CAMonitorLoc",{
					valueField:'ID',
					textField:'LocDesc2',
					editable:true,
					data:obj.CAMonitorLocList,
					onSelect:function(rec){//给医院增加Select事件，更新科室列表
						$('#HisApplyList').datagrid('load',{
				 	 		ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				        	QueryName:'QryEvReportByMonth',
				        	aHospIDs:$("#cboHospital").combobox('getValue'),
				        	aMonth:monthlist[0].id,
				        	aDate:$('#CAMonitorDate').datebox('getValue'),
				        	aMonitorLoc:$("#CAMonitorLoc").combobox('getValue')
						});
					}
					
				});
			}

			$('#CAMonitorLoc').combobox('setValue',LogonLocID);
			$('#CAMonitorLoc').combobox('setText',LogonLocDesc);
			var monthlist=$m({
				ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				MethodName:'GetLastMonth'	
			},false)
			var monthlist=eval(monthlist);
			$("#MonthList").keywords({
	            onSelect:function(v){
		            DateID=v.id
		            $('#HisApplyList').datagrid('load',{
						ClassName:'DHCHAI.IRS.EnviHyReportSrv',
				        QueryName:'QryEvReportByMonth',
				        aHospIDs:$("#cboHospital").combobox('getValue'),
			        	aMonth:v.id,
			        	aDate:$('#CAMonitorDate').datebox('getValue'),
			        	aMonitorLoc:$("#CAMonitorLoc").combobox('getValue')
					});
					$('#HisApplyList').datagrid('unselectAll');
		        },
	            singleSelect:true,
	         
	            items:monthlist
	          
			})
			 		
          	$('#HisApplyList').datagrid({
		        fit:true,
		        headerCls:'panel-header-gray',
		        rownumbers:true,
		        striped:true,
		        singleSelect:false,
		        fitColumns:false,
		        url:$URL,
		        bodyCls:'no-border',
		        queryParams:{
			        ClassName:'DHCHAI.IRS.EnviHyReportSrv',
			        QueryName:'QryEvReportByMonth',
			        aHospIDs:$("#cboHospital").combobox('getValue'),
			        aMonth:monthlist[0].id,
			        aDate:$('#CAMonitorDate').datebox('getValue'),
			        aMonitorLoc:$("#CAMonitorLoc").combobox('getValue')
			    },
		        columns:[[
		        	{ field:'checked',checkbox:'true',align:'center',width:30},
		        	{ field:"MonitorLocDesc",title:"监测科室",width:160},
					{ field:"EvItemDesc",title:"监测项目",width:200},
					{ field:"EvItemObjDesc",title:"监测对象",width:105},
					{ field:"MonitorDate",title:"监测日期",width:100},
					{ field:"SpenTypeDesc",title:"标本类型",width:100},
					{ field:"SpecimenNum",title:"标本数量",width:100},
					{ field:"StandardDesc",title:"是否合格",width:102}
		        ]]  
          	})  
          	var DateNow=Common_GetDate(new Date());
    		$('#CAMonitorDate').datebox('setValue',DateNow); 
		}
	})
	/*申请单监测结果明细*/

			$('#ReCheck').dialog({
			title: '不合格复检',
			iconCls:"icon-w-paper",
			closed: true,
			modal: true
		});
	//刷新历史申请单
	InitEnviHyApplyWinEvent(obj);
	obj.loadEvents();
	$(".datebox-button table td").css("text-align","center");
	$(".datebox .validatebox-text").css("width","153px");
	$('#northP .panel-body').css('width','850px') 
	$('#northP').css('padding-left','3px') 

	return obj;
}
