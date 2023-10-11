var obj = new Object();
$(function () {
	
	//加载树
	ShowTree();
	//加载表格
	InitBactDailyWin();

	 //初始化医院
    var HospList = $cm ({
		ClassName:"DHCHAI.BTS.HospitalSrv",
		QueryName:"QryHospListByLogon",
		aLogonHospID:$.LOGON.HOSPID
	},false);
	$HUI.combobox("#cboHospital",{
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		data:HospList.rows,
		onChange: function(newValue, oldValue){   //选中重新加载信息
			if ($('#dtRepDate').datebox('getValue')) {
				ResultTreeShow();
			}
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$('#dtRepDate').datebox('setValue', Common_GetCalDate(-1));
	LoadResult();
});
    
$('#dtRepDate').datebox({
	onChange: function(newValue, oldValue){
		if ($('#cboHospital').datebox('getValue')) {
			ResultTreeShow();
		}
	}
});
function ShowTree() {
	var dataArr=$cm({
		ClassName:"DHCHAI.IRS.BactDailySrv",
		MethodName:"ResultTree"
	},false)
	var checkNode="";
	$('#ResultTree').tree({
		autoNodeHeight:true,
		lines:true,
		data: dataArr,
		formatter:function(node){
			if (node.children){
				return node.text;
			}else{
				return node.text;
			}
		},
		onSelect: function(node){
			if (checkNode!=node.id){ //首次选中
				checkNode = node.id;
			}else{  //再次选中取消选中
				checkNode ="";
				$('#ResultTree').find('.tree-node-selected').removeClass('tree-node-selected');
			}
			LoadResult();
	    }
	});
}

function ResultTreeShow() {
	var Sum=0,InfType0=0,InfType1=0,InfType2=0,InfType3=0,InfType4=0,InfType5=0,InfType6=0,InfType7=0,TypeRNum=0,TypeSNum=0
	var TreeData =$m({
		ClassName:"DHCHAI.IRS.BactDailySrv",
		MethodName:"GetTreeData",
		aHospIDs:$('#cboHospital').combobox('getValue'),
		aRepDate:$('#dtRepDate').datebox('getValue')
	},false);

	if (!TreeData) return;	
	InfType0 =TreeData.split("^")[0];
	InfType1 =TreeData.split("^")[1];
	InfType2 =TreeData.split("^")[2];
	InfType3 =TreeData.split("^")[3];
	InfType4 =TreeData.split("^")[4];
	InfType5 =TreeData.split("^")[5];
	InfType6 =TreeData.split("^")[6];
	InfType7 =TreeData.split("^")[7];
	TypeSNum =TreeData.split("^")[8];
	TypeRNum =TreeData.split("^")[9];	
	Sum =TreeData.split("^")[10];
	
	$('#InfSum').text(Sum);
	$('#TypeSum').text(Sum);
	$('#TypeRNum').text(TypeRNum);
	$('#TypeSNum').text(TypeSNum);
	$('#InfType0').text(InfType0);
	$('#InfType1').text(InfType1);
	$('#InfType2').text(InfType2);
	$('#InfType3').text(InfType3);
	$('#InfType4').text(InfType4);
	$('#InfType5').text(InfType5);
	$('#InfType6').text(InfType6);
	$('#InfType7').text(InfType7);	
	
	LoadResult();
		
}

/*
//日报结果树
function ResultTreeShow() {
	var checkNode="";
    $m({
		ClassName:"DHCHAI.IRS.BactDailySrv",
		MethodName:"GetResultTree",
		aHospIDs:$('#cboHospital').combobox('getValue'),
		aRepDate:$('#dtRepDate').datebox('getValue')
	},function(rs){
		var dataArr=$.parseJSON(rs);
		$('#ResultTree').tree({
			autoNodeHeight:true,
			lines:true,
			data: dataArr,
			formatter:function(node){
				if (node.children){
					return node.text;
				}else{
					return node.text;
				}
			},onSelect: function(node){
				if (checkNode!=node.id){ //首次选中
					checkNode = node.id;
				}else{  //再次选中取消选中
					checkNode ="";
					$('#ResultTree').find('.tree-node-selected').removeClass('tree-node-selected');
				}
				LoadResult();
		    },onLoadSuccess	: function(node, data){
		        LoadResult();
		    },
		})
	});
}
*/
//加载表格数据
function LoadResult(){
	var HospIDs  = $("#cboHospital").combobox('getValue');
	var RepDate = $("#dtRepDate").datebox('getValue');
	var Treeselected = $('#ResultTree').tree('getSelected');
	var MRBType =""
	var InfType =""
	if (Treeselected) {
		if((Treeselected.id).indexOf('InfType')>-1)	 {
			InfType =(Treeselected.id).split("_")[1]; 
		}else if((Treeselected.id).indexOf('MRBType')>-1)	 {
			MRBType =(Treeselected.id).split("_")[1]; 
		}
	}

	var ErrorStr="";
	if (HospIDs=="") {
		ErrorStr += '请选择院区!<br/>';
	}		
	if(RepDate==""){
		ErrorStr += '报告日期不能为空!<br/>';
	}

	if (ErrorStr != '') {
		$.messager.alert("错误提示",ErrorStr, 'info');
		return;
	}else{
		$("#girdDailyResult").datagrid("loading");
		$cm ({
			ClassName:"DHCHAI.IRS.BactDailySrv",
			QueryName:"QryDailyResult",
			ResultSetType:"array",
			aHospIDs:HospIDs,
			aRepDate:RepDate,
			aInfType:InfType,
			aMRBType:MRBType,
			page:1,
			rows:9999
		},function(rs){
			$('#girdDailyResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
		});
	
	}
}

function InitBactDailyWin() {

    //细菌检出日报
    obj.girdDailyResult=$('#girdDailyResult').datagrid({
        fit:true,
        title:'细菌检出日报',
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true},
	        { field:"MrNo",title:"病案号",width:100,sortable:true},
			{ field:"PatName",title:"姓名",width:100,sortable:true},
			{ field:"AdmWardDesc",title:"就诊病区",width:150,sortable:true},
			{ field:"LabLocDesc",title:"送检科室",width:120,sortable:true},
			{ field:"LabWardDesc",title:"送检病区",width:150,sortable:true},
			{ field:"RecDate",title:"送检日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"RepDate",title:"报告日期",width:100,sortable:true,sorter:Sort_int},	
			{ field:"Specimen",title:"标本",width:100,sortable:true},
			{ field:"Bacteria",title:"细菌",width:150,sortable:true},
			{ field:"MRBDesc",title:"多耐类型",width:200,showTip:true,sortable:true}, 
			{ field:"InfTypeDesc",title:"感染类型",width:120,sortable:true,
					formatter:function(value,row,index){
					var ResultID=row["LabResultID"];					 
					if (value!=""){
						return '<a href="#" style="color:#000" onclick="obj.MenuEdit(\'' +index + '\',\'' + ResultID + '\')">'+value+'</a>';
					}else{
						return '<a href="#" onclick="obj.MenuEdit(\'' +index + '\',\'' + ResultID + '\')">标记</a>';
					}
				}
			},

			{ field:"link",title:"药敏结果",width:80,sortable:true,
				formatter:function(value,row,index){
					return '<a href="#" onclick="obj.OpenReslut(\'' + row.LabResultID + '\')">药敏结果</a>';
				}
			},
			{ field:"ZY",title:"摘要",width:80,
				formatter:function(value,row,index){
					 var EpisodeID = row["EpisodeDr"];
					 return '<a href="#" onclick="obj.OpenMainView(\'' + EpisodeID + '\')">摘要</a>';
				}
			},
			{ field:"expander",title:"电子病历",width:80,sortable:true,
				formatter:function(value,row,index){
					return '<a href="#" onclick=obj.OpenEmrRecord(\''+row.EpisodeID+'\',\''+row.PatientID+'\')>病历浏览</a>';
				}
			},
			{ field:"Sex",title:"性别",width:50,sortable:true},
			{ field:"Age",title:"年龄",width:80,sortable:true},
			{ field:"AdmDate",title:"入院日期",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"出院日期",width:100,sortable:true,sorter:Sort_int}
		]],
		rowStyler: function (index, row) {
        	if (row.InfTypeDesc == "HA(院内感染)") {
         		return 'color:red;';
        	}
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	obj.gridIRDrugSen=$('#gridIRDrugSen').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"AntDesc",title:"抗生素",width:400},
			{ field:"Sensitivity",title:"药敏结果",width:320,
				formatter: function(value,row,index){
					if (row.IsInt==1) {
						return value +'<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:3px;width:20px;height:20px;font-weight: 600;">天</div>';
					}else {
						return value;
					}						
				}		
			}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });

    InitBactDailyWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
