//页面Gui
var objScreen = new Object();
function InitActualSufferingWin(){
	var obj = objScreen;
	obj.DiagnosID='';
	obj.IsReportDiag ='';
	$.parser.parse(); // 解析EasyUI组件
	
	//设置开始日期和结束日期为本月第一天
	var date=new Date()
	//date.setDate(1);
	var DateFrom=Common_GetDate(date)
	Common_SetValue('DateFrom',DateFrom);
    //医院
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			var HospIDs=$('#cboHospital').combobox('getValue');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			//科室病区
			Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
		},
		onLoadSuccess:function(data){
			// 院区默认选择
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	//$('#cboLoc').combobox({}); //联动表格需先初始化	
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	obj.LocType="W"
	var unitConfig = $m({
		ClassName: "DHCHAI.BT.Config",
		MethodName: "GetValByCode",
		aCode: "StatV2ScreenuUnit",
		aHospDr: $.LOGON.HOSPID
	},false);
	if (unitConfig) {
		if (unitConfig == 'E') {
			$HUI.radio("#chkStatunit-Loc").setValue(true);
		}
	}
	
	$HUI.radio("[name='chkStatunit']",{
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs =  $("#cboHospital").combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
		      	//科室病区
				Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
				obj.LocType=LocType
			 }, 200);
        }
    });

	obj.gridActualSuffering=$('#ActualSuffering').datagrid({
        fit:true,
        title:'实时现患病例列表',
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
	    	frozenColumns:[[    
                    { field:"MrNo",title:"病案号",width:'100',sortable:true},
            { field:"PatName",title:"姓名",width:'80',sortable:true}
            ]], 
            columns:[[
          
            { field:"AdmTimes",title:"住院次数",width:'100',sortable:true},
            { field:"Sex",title:"性别",width:'80',sortable:true},
            { field:"SortAge",title:"年龄",width:'60',sortable:true,
                sorter:function(a,b){  
                    var number1 = parseFloat(a);
                    var number2 = parseFloat(b);
                    return (number1 > number2 ? 1 : -1);
                },
                formatter: function(value,row,index){
                    return row.Age;
                }
            },
            { field:"AdmDate",title:"入院时间",width:'150',sortable:true,sorter:Sort_int},
            { field:"expander",title:'摘要',width:'50',
                formatter: function(value,row,index){
                    return " <a href='#' onclick='objScreen.OpenView(\"" + row.EpisodeID + "\");'>摘要</a>";
                }
            },
            { field:"CurrAdmLoc",title:"当前科室",width:'150',sortable:true},
            { field:"CurrAdmBed",title:"当前床位",width:'150',sortable:true},
            { field:"expander1",title:"转归处理",width:'230',
                formatter: function(value,row,index){
                    var InfPos = row["HosInfPosDesc"]+(row["ComInfPosDesc"]!=""?("#"+row["ComInfPosDesc"]):"");
                    var DiasID = row["HosInfDias"]+(row["ComInfDias"]!=""?("#"+row["ComInfDias"]):""); 
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
                                InfPosHtml += '<a href="#" style="line-height:20px;" onclick="objScreen.OpenInfPosDialog(\''+ row.EpisodeID + '\',\''+ DiasIDArray[i] + '\',\''+ row.AdmitDate + '\',\''+ row.DischDate + '\')">' + InfPosArray[i] + '</a>'+"<br/>";
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
            { field:"yscl",title:"疑似处理",width:'100',sortable:true,
                formatter: function(value,row,index){       
                    return '<a href="#" onclick="objScreen.PatScreenShow(\'' + row.EpisodeID + '\')">' + value + '</a>';            
                }
            },
            { field:"InfSubDesc",title:"感染分类",width:'180',sortable:true},
            { field:"HosInfDate",title:"医院感染日期",width:'120',showTip:true,sortable:true,sorter:Sort_int},
            { field:"HosIRBacteria",title:"医院感染病原体",width:'150',showTip:true,sortable:true},
            { field:"ComInfDate",title:"社区感染日期",width:'120',showTip:true,sortable:true,sorter:Sort_int},
            { field:"ComIRBacteria",title:"社区感染病原体",width:'150',showTip:true,sortable:true},
            { field:"AllDiag",title:"疾病诊断",width:'200',showTip:true,sortable:true},
            { field:"OBSCnt",title:"过去24时内腹泻",width:'150',sortable:true},
            { field:"AntiIsUser",title:"是否使用抗生素",width:'150',sortable:true},
            { field:"AntUsePurpose",title:"使用目的",width:'100',sortable:true},
            { field:"CombinedMed",title:"联用情况",width:'100',sortable:true},
            { field:"AntIsInspected",title:"使用前是否送检",width:'150',sortable:true},
            { field:"OperFlagDesc",title:"是否手术",width:'100',sortable:true},
            { field:"OperDesc",title:"手术名称",width:'100',showTip:true,sortable:true},
            { field:"CuteType",title:"切口类型",width:'100',sortable:true},
            { field:"IsPICC",title:"血管导管插管",width:'120',sortable:true},
            { field:"IsVAP",title:"呼吸机插管",width:'120',sortable:true},
            { field:"IsUC",title:"导尿管插管",width:'120',sortable:true}
        ]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
	

	InitActualSufferingWinEvent(obj);
	obj.LoadEvent(arguments);

	return obj;
}
