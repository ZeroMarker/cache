//页面Gui
var objScreen = new Object();

function InitPatFindWin(){
	var obj = objScreen;
	obj.Params="";
$(".line").css("display","none")
	//管理员权限
	obj.AdminPower=0;
	if (tDHCMedMenuOper['Admin']==1) {
		obj.AdminPower =1;
	}
	
	///加载编号(加载编号[默认加载最近一条][显示]  管理员:可选,非管理员:不可选)
	$HUI.combobox("#cboSurvNumber",{
		url:$URL+'?ClassName=DHCHAI.IRS.INFCSSSrv&QueryName=QueryByCode&ResultSetType=Array&aHospIDs='+$.LOGON.HOSPID+'&aFlag='+obj.AdminPower,
		valueField:'ID',
		textField:'SESurvNumber',
		onLoadSuccess:function(data){
			//默认选中最新一条
			$("#cboSurvNumber").combobox('select',data[0].ID);
			if(tDHCMedMenuOper['Admin']!=1) {
				$('#cboSurvNumber').combobox('disable');
			}
		}
	});
	$("#btnChkReps").hide();
	$("#btnUnChkReps").hide();
	$(".line").css("display","none")
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			if (Status=="2"){
				$(".line").css("display","block")
				$("#btnChkReps").show();
				$("#btnUnChkReps").hide();
			}else if (Status=="3"){
				$(".line").css("display","block")
				$("#btnUnChkReps").show();
				$("#btnChkReps").hide();
			}else{
				$(".line").css("display","none")
				$("#btnChkReps").hide();
				$("#btnUnChkReps").hide();
			}
			obj.reloadgridApply();
		},
		onUnchecked:function(e,value){
			$("#btnChkReps").hide();
			$("#btnUnChkReps").hide();
		}
	});
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
				Common_ComboToLoc('cboLocation',rec.ID,"","I");
			},onLoadSuccess:function(data){
				// 院区默认选择
				$('#cboHospital').combobox('select',data[0].ID);
			}
		});
	 $HUI.combobox("#cboLocation",{
			onLoadSuccess:function(data){
				// 院区默认选择
				if(tDHCMedMenuOper['Admin']!=1) {
					$("#cboLocation").combobox('setValue',$.LOGON.LOCID);
					$("#cboLocation").combobox('setText',$.LOGON.LOCDESC);
					$('#cboLocation').combobox('disable');
					$('#cboHospital').combobox('disable');
				}
			}
		});
    Common_ComboDicID("cboInfCategoryDr","IRCSSINFTYPE");
	obj.gridApply=$('#gridApply').datagrid({
        fit:true,
        toolbar:'#ToolBar',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:false,
        singleSelect:false,
        autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		loading:true,
                ClassTableName:'DHCHAI.IR.INFCSS',
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		//分页
		pageSize: 20,
		pageList : [20,50,100,500,1000,10000],
	    columns:[[
	    	{field:'checkOrd',checkbox:'true',width:'80',auto:false},
			{title:'调查状态',width:80,field:'RepStatus',
				formatter:function(value,row,index){
					var ReportID = row["RepID"];
					var EpisodeID = row["EpisodeID"];
					var SurvNumber = row["SurvNumber"];
					if (value=="未调查"){
						var RepStatus=1;
					}else if (value=="已调查"){
						var RepStatus=2;
					}else{
						var RepStatus=3;
					}
					 return '<a href="#" onclick="objScreen.OpenReport(\'' + EpisodeID + '\',\'' + SurvNumber + '\',\'' + ReportID+ '\',\''+ index+ '\',\'' + RepStatus + '\')">'+value+'</a>';
				}
			}, 
			{ field:"SurLocDesc",title:"调查科室/病区",width:180,sortable:true,sorter:Sort_int},
			{ field:"PapmiNo",title:"登记号",width:100,sortable:true,sorter:Sort_int},
			{ field:"MrNo",title:"病案号",width:100,sortable:true,sorter:Sort_int},
			{ field:"PatName",title:"姓名",width:70,sortable:true,sorter:Sort_int},
			{ field:"Sex",title:"性别",width:50,sortable:true,sorter:Sort_int},
			{ field:"Age",title:"年龄",width:50,sortable:true,sorter:Sort_int},
			{ field:"IdentityCode",title:"身份证号",width:180,sortable:true,sorter:Sort_int},
			{ field:"AdmBed",title:"床位",width:70,sortable:true,sorter:Sort_int},
			{ field:"AdmDoc",title:"管床医师",width:80,sortable:true,sorter:Sort_int},
			{ field:"ZY",title:"摘要",width:60,
				formatter:function(value,row,index){
					 var EpisodeID = row["EpisodeID"];
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + EpisodeID + '\')">摘要</a>';
				}
			},
			{ field:"DiagnosDesc",title:"疾病诊断",width:200,showTip:true,sortable:true,sorter:Sort_int},
			{ field:"OBSCnt",title:"过去24小时</br>内是否腹泻",width:100,sortable:true,sorter:Sort_int},
			{ field:"OperFlag",title:"是否手术",width:80,sortable:true,sorter:Sort_int},
			{ field:"CuteType",title:"切口类型",width:120,showTip:true,sortable:true,sorter:Sort_int},
            /*{ field:"YYInfPos11Desc",title:"感染信息",width:200,sortable:true,sorter:Sort_int,
                formatter:function(value,row,index){
                     var YYInfPos11Desc = row["YYInfPos11Desc"];
                     var YYInfPos21Desc = row["YYInfPos21Desc"];
                     var YYInfPos31Desc = row["YYInfPos31Desc"];
                     var InfPosDescs=""
                     if(YYInfPos11Desc!="") InfPosDescs=YYInfPos11Desc
                     if(YYInfPos21Desc!="") InfPosDescs=InfPosDescs+"^"+YYInfPos21Desc
                     if(YYInfPos31Desc!="") InfPosDescs=InfPosDescs+"^"+YYInfPos31Desc
                     
                     return InfPosDescs;
                }
            },*/
            
            { field:"InfectionDesc",title:"是否感染",width:100,sortable:true,sorter:Sort_int},
            { field:"InfCateDesc",title:"感染分类",width:100,sortable:true,sorter:Sort_int},
            { field:"FirInfDate",title:"首次医院感染日期",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos11Desc",title:"医院感染部位1",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria11Desc",title:"HA病原体11",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria12Desc",title:"HA病原体12",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria13Desc",title:"HA病原体13",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos21Desc",title:"医院感染部位2",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria21Desc",title:"HA病原体21",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria22Desc",title:"HA病原体22",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria23Desc",title:"HA病原体23",width:120,sortable:true,sorter:Sort_int},
            { field:"YYInfPos31Desc",title:"医院感染部位3",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria31Desc",title:"HA病原体31",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria32Desc",title:"HA病原体32",width:120,sortable:true,sorter:Sort_int},
            { field:"YYBacteria33Desc",title:"HA病原体33",width:120,sortable:true,sorter:Sort_int},
            { field:"OprInfDesc",title:"手术后肺炎",width:80,sortable:true,sorter:Sort_int},
            { field:"ComInfPos1",title:"社区感染部位1",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod1",title:"发生方式1",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria11",title:"CA病原体11",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria12",title:"CA病原体12",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria13",title:"CA病原体13",width:120,sortable:true,sorter:Sort_int},
            { field:"ComInfPos2",title:"社区感染部位2",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod2",title:"发生方式2",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria21",title:"CA病原体21",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria22",title:"CA病原体22",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria23",title:"CA病原体23",width:120,sortable:true,sorter:Sort_int},
            { field:"ComInfPos3",title:"社区感染部位3",width:120,sortable:true,sorter:Sort_int},
            { field:"SQMethod3",title:"发生方式3",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria31",title:"CA病原体31",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria32",title:"CA病原体32",width:120,sortable:true,sorter:Sort_int},
            { field:"ComBacteria33",title:"CA病原体33",width:120,sortable:true,sorter:Sort_int},
            { field:"IRAntiFlag",title:"是否使用</br>抗生素",width:80,sortable:true,sorter:Sort_int},
            { field:"PurposeDesc",title:"使用目的",width:100,sortable:true,sorter:Sort_int},
            { field:"CombinDesc",title:"联用情况",width:80,sortable:true,sorter:Sort_int},
            { field:"IRAntiSenFlag",title:"治疗用药已送细菌培养",width:100,sortable:true,sorter:Sort_int},
            { field:"IROperAntiFlag",title:"送培养时机为抗菌药物使用前",width:100,sortable:true,sorter:Sort_int},
            { field:"AdmDate",title:"入院日期",width:120,sortable:true,sorter:Sort_int},
            { field:"DischDate",title:"出院日期",width:120,sortable:true,sorter:Sort_int},
            { field:"AdmTimes",title:"住院次数",width:80,sortable:true,sorter:Sort_int}, 
            { field:"CSSSpecGLFlag",title:"标本革兰染色",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecKSFlag",title:"标本抗酸染色",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecMZFlag",title:"标本墨汁染色",width:120,sortable:true,sorter:Sort_int},
            { field:"CSSSpecJYFlag",title:"标本基因测序",width:120,sortable:true,sorter:Sort_int},
            { field:"EpisodeID",title:"就诊唯一标识",width:120,sortable:true,sorter:Sort_int}
            
			]],
		onSelect:function(rowIndex,rowData){
			obj.rowIndex=rowIndex;
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
            $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
            $(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}
    });
        ShowUserHabit('gridApply');
	

	InitPatFindWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
