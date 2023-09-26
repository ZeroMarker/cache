//页面Gui
var objScreen = new Object();
function InitActualSufferingWin(){
	var obj = objScreen;
	obj.DiagnosID='';
	obj.IsReportDiag ='';
	$.parser.parse(); // 解析EasyUI组件
	
	//设置开始日期和结束日期为本月第一天
	var date=new Date()
	date.setDate(1);
	var DateFrom=Common_GetDate(date)
	Common_SetValue('DateFrom',DateFrom);
    Common_SetValue('DateTo',Common_GetDate(new Date()));
    //医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLoc',rec.ID,"","I","");
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#cboLoc').combobox({}); //联动表格需先初始化	
	
	obj.gridActualSuffering=$('#ActualSuffering').datagrid({
        fit:true,
        title:'实现现患病例列表',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:true,
        fitColumns:true,
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"MrNo",title:"病案号"},
			{ field:"PatName",title:"姓名"},
			{ field:"AdmTimes",title:"住院次数"},
			{ field:"Sex",title:"性别"},
			{ field:"Age",title:"年龄"},
			{ field:"expander",title:'摘要',
				formatter: function(value,row,index){
					return " <a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
				}
			},
			{ field:"InfPosDescs",title:"转归处理",
				formatter: function(value,row,index){
					var InfPos = row["InfPosDescs"];
					var DiasID = row["InfDias"];
					var InfPosArray = InfPos.split("#");
					var DiasIDArray = DiasID.split("#");
					var InfPosHtml = "";
					for (var i=0; i<InfPosArray.length; i++){
						var InfDiag = $m({
							ClassName:"DHCHAI.IRS.INFDiagnosSrv",
							MethodName:"GetStrByRowID",
							aID:DiasIDArray[i]
						},false);
						if (!InfDiag) return;
						var InfDiagArray = InfDiag.split("^");
						if (InfDiagArray){
							var txtInfXDate = InfDiagArray[10];
							if (txtInfXDate == ""){
								InfPosHtml += '<a href="#" style="line-height:30px;" onclick="objScreen.OpenInfPosDialog(\''+ row.EpisodeID + '\',\''+ DiasIDArray[i] + '\',\''+ row.AdmitDate + '\',\''+ row.DischDate + '\')">' + InfPosArray[i] + '</a>'+"<br/>";
							}else{
								InfPosHtml += InfPosArray[i]+"<br/>";
							}
						}
						
					}
					if (InfPosHtml.length != 0){
						InfPosHtml = InfPosHtml.substring(0,InfPosHtml.length-1);
					}
					return InfPosHtml;
				}
			},
			//疑似处理
			{ field:"yscl",title:"疑似处理",
				formatter: function(value,row,index){		
					return '<a href="#" onclick="objScreen.PatScreenShow(\'' + row.EpisodeID + '\')">' + value + '</a>';			
				}
			},
			{ field:"AllDiag",title:"疾病诊断"},
			{ field:"OBSCnt",title:"过去24时内腹泻"},
			{ field:"AntiIsUser",title:"是否使用抗生素"},
			{ field:"AntUsePurpose",title:"使用目的"},
			{ field:"CombinedMed",title:"联用情况"},
			{ field:"AntIsSubmiss",title:"使用前是否送检"},
			{ field:"OperFlagDesc",title:"是否手术"},
			{ field:"CuteType",title:"切口类型"},
			{ field:"BacDescs",title:"细菌耐药情况"}
        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	

	InitActualSufferingWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
