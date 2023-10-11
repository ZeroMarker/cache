/**
* @author songchunli
* HISUI 床管中心宁医大版本主js
*/
var PageLogicObj={
	SelWardLocStr:[]
}
$(function(){
	Init();
	InitEvent();
})
function Init(){
	InitSearchLocGroup();
	initPatSchCondition();
	InitAppWardListTab();
	InitTip();
}
function InitEvent(){
	$("#findAppPatListBtn").click(function(){
		var RegNO=$("#SearchRegNO").val();
		var CardNo=$("#SearchCardNo").val();
		if ((CardNo!="")&&(RegNO=="")){
			var myrtn = DHCACC_GetAccInfo("", CardNo, "", "", "CardNoKeyDownCallBack");
            return false;
		}else{
			findAppPatList();
		}
	});
	$('#readCardBtn').click(readCardBtnClick); 
	$('#exportBtn').click(exportBtnClick); 
	document.onkeydown = DocumentOnKeyDown;
}
$(window).load(function() {
	$("#loading").hide();
})
//卡号，登记号，住院证号回车事件调用的方法
function DocumentOnKeyDown(e) {
    if (window.event) {
        var keyCode = window.event.keyCode;
        var type = window.event.type;
        var SrcObj = window.event.srcElement;
    } else {
        var keyCode = e.which;
        var type = e.type;
        var SrcObj = e.target;
    }
    if (keyCode == 13) {
        if (SrcObj && (SrcObj.id.indexOf("SearchCardNo") >= 0)) {
            var CardNo = $('#SearchCardNo').val();
            if (CardNo == "") return;
            var myrtn = DHCACC_GetAccInfo("", CardNo, "", "", "CardNoKeyDownCallBack");
            return false;
        } else if (SrcObj && (SrcObj.id.indexOf("SearchRegNO") >= 0)) {            if ($("#SearchRegNO").val().length < 10) {
                var temReg = $("#SearchRegNO").val();
                if (temReg == "") return;
                for (var k = 0; k < 10 - $("#SearchRegNO").val().length; k++) {
                    temReg = "0" + temReg;
                }
                $("#SearchRegNO").val(temReg);
            }
            $("#bookNO").val("");
            $('#SearchCardNo').val("");
            findAppPatList();
        } else if (SrcObj && SrcObj.id.indexOf("bookNO") >= 0) {
            findAppPatList();
            $('#SearchCardNo').val("");
        }
        return true;
    }
}
//卡号查询信息回调函数
function CardNoKeyDownCallBack(myrtn) {
    var myary = myrtn.split("^");
    var rtn = myary[0];
    switch (rtn) {
        case "0":
            var PatientID = myary[4];
            var PatientNo = myary[5];
            var CardNo = myary[1];
            $("#SearchCardNo").val(CardNo);
            $("#SearchRegNO").val(PatientNo);
            findAppPatList();
            break;
        case "-200":
            $.messager.alert("提示", "卡无效!", "info", function() {
                $("#CardTypeNew,#SearchRegNO").val("");
                $("#SearchCardNo").focus();
            });
            break;
        case "-201":
            var PatientID = myary[4];
            var PatientNo = myary[5];
            var CardNo = myary[1];
            $("#SearchCardNo").val(CardNo);
            $("#SearchRegNO").val(PatientNo);
            findAppPatList();
            break;
        default:
            break;
    }
}
function readCardBtnClick() {
    function setCardNo(myrtn) {
	    var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
			case "0": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#SearchCardNo").val(CardNo);
	    		$("#SearchRegNO").val(PatientNo);
	    		findAppPatList();
				break;
			case "-200": 
				$.messager.alert("提示","卡无效!","info",function(){
					$("#CardTypeNew,#SearchRegNO").val("");
					$("#SearchCardNo").focus();
				});
				break;
			case "-201": 
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
	    		$("#SearchCardNo").val(CardNo);
	    		$("#SearchRegNO").val(PatientNo);
	    		findAppPatList();
				break;
			default:
				break;
		}
    }
    DHCACC_GetAccInfo7(setCardNo);
}
function findAppPatList(){
	setTimeout(function(){
		$('#PatBookListTab').datagrid("reload");
	})
}
function InitSearchLocGroup(){
	$('#SearchLocGroup').combobox({
        valueField: 'id',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManageV2&MethodName=getLocGroupList',
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        },
        onSelect:function(rec){
	        filterWardsData();
	    },onChange:function(newValue, oldValue){
		    filterWardsData();
		}
    })
}
function InitAppWardListTab(){
	var Columns=[[ 
		{ field: 'wardID', checkbox: 'true'},
		{ field: 'WardDesc', title: '病区',width:140,
			styler: function(value,row,index){
				if (row["EmptyNum"] == "0"){
					return 'color:red;'
				}else if(row["EmptyNum"] < 10){
					return 'color:orange;'
				}else  if(row["EmptyNum"] >= 10){
					return 'color:green;'
				}
			}
		},
		{ field: 'EmptyNum', title: '空床数',width:70},
		{ field: 'TotalNum', title: '总床',width:70},
		//{ field: 'PatName', title: '待办人数',width:50},
		{ field: 'OtherNum', title: '不限',width:50},
		{ field: 'MaleNum', title: '男床',width:50},
		{ field: 'FeMaleNum', title: '女床',width:50},
		{ field: 'LockNum', title: '锁定',width:50},
		{ field: 'AvailNum', title: '可用',width:50},
		{ field: 'UnavailNum', title: '不可用',width:70},		
		{ field: 'InHosNum', title: '在院人数',width:90},
		{ field: 'AppointNum', title: '预约人数',width:90},
		{ field: 'BedRate', title: '床位使用率',width:90},
		{ field: 'leavePatients', title: '今出/明出',width:90},
		{ field: 'CTLBDesc', title: '位置',width:150}
    ]];
	$('#AppWardListTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('加载中..'),  
		pagination : false, 
		rownumbers : false,
		idField:"WardID",
		columns :Columns,
		titleNoWrap:false,
		//nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.InService.AppointManageV2&QueryName=findWardBedSummery",
		onBeforeLoad:function(param){
			PageLogicObj.SelWardLocStr=[];
			$('#AppWardListTab').datagrid("unselectAll");
			param = $.extend(param,{
				WardCode:$("#SearchWard").searchbox('getValue'),
				SearchLocGroup:$("#SearchLocGroup").combobox("getValue"),
				hospitalId:session['LOGON.HOSPID']
			});
		},
		onSelect:function(rowIndex, rowData){
			WardSelectChange();
		},
		onUnselect:function(rowIndex, rowData){
			WardSelectChange();
		},
		onLoadSuccess:function(data){
			findAppPatList();
		},
		onSelectAll:function(data){
			WardSelectChange();
		},
		onUnselectAll:function(data){
			WardSelectChange();
		}
	})
}
function WardSelectChange(){
	PageLogicObj.SelWardLocStr=[];
	var AppWardArr=[],AppLocArr=[];
	var sels=$("#AppWardListTab").datagrid("getSelections");
	for (var i=0;i<sels.length;i++){
		AppWardArr.push({"id":sels[i]["WardLocID"],"desc":sels[i]["WardDesc"]});
		var WardLinkLocStr=sels[i]["WardLinkLocStr"];
		var WardLinkLocDescStr=sels[i]["WardLinkLocDescStr"];
		for (var j=0;j<WardLinkLocStr.split("^").length;j++){
			var index=$.hisui.indexOfArray(AppLocArr,"id",WardLinkLocStr.split("^")[j]);
			if (index < 0){
				AppLocArr.push({"id":WardLinkLocStr.split("^")[j],"desc":WardLinkLocDescStr.split("^")[j]});
			}
		}
		PageLogicObj.SelWardLocStr.push(sels[i]["WardLocID"]);
	}
	$("#SearchAppLoc,#SearchAppWard").combobox("select","");
	$("#SearchAppWard").combobox("loadData",AppWardArr);
	$("#SearchAppLoc").combobox("loadData",AppLocArr);
	if ($('#PatBookListTab').datagrid().length > 0){
		$('#PatBookListTab').datagrid("reload");
	}
}
function filterWardsData(){
	$('#AppWardListTab').datagrid("reload");
}
// PatName,Sex,IllStatus,Notes,RegDate,WaitDay,OperDate,OperName,BookNO,RegNO,TreatedPrinciple,BookStatus
// Age,LinkManPhone,Diagnosis,InSourceDesc,AdmInitState,CreateLoc,appLocDesc,appWardDesc
function InitPatBookListTab(){
	var Columns=[[ 
		{ field: 'Diagnosis', title: '诊断',width:100},
		{ field: 'InSourceDesc', title: '入院途经',width:50,
			styler: function(value,row,index){
				if (value == "急诊"){
					return 'color:red;'
				}
			}
		},
		{ field: 'illState', title: '病情',width:50,
			styler: function(value,row,index){
				if (value){
					return 'background-color:'+GetIllLevelColor(row["illStateCode"]) || '#fff'+';color:#fff;';
				}
			}
		},
		{ field: 'WaitDay', title: '等候天数',width:50},
		{ field: 'CreateLoc', title: '开证科室',width:100},		
		{ field: 'appLocDesc', title: '预约科室',width:100},
		{ field: 'appWardDesc', title: '预约病区',width:130},
		{ field: 'AppBedCode', title: '预约床位',width:80},
		{ field: 'AppDate', title: '预约日期',width:90},
		{ field: 'JCOrdRate', title: '检查进度',width:50,
			formatter: function(value,row,index){
				var html="";
				/*if (value !== ""){
					if (value == "0%"){
						if (bookingOperation!="N") html = '<a class="editcls" style="background-color:#0E8BDD;" onclick="ShowRisWorkWin(\'' + row["BookNO"] + '\')">'+$g("预约")+'</a>';
						else html='<a class="editcls1" onclick="ShowRisProgress(\'' + row["BookNO"] + '\')">'+value+'</a>';;
					}else{
						html = '<a class="editcls1" onclick="ShowRisProgress(\'' + row["BookNO"] + '\')">'+value+'</a>';
					}
					return html;
				}*/
				if (value != ""){
					html = '<a class="editcls1" onclick="ShowRisProgress(\'' + row["BookNO"] + '\')">'+value+'</a>';
				}else{
					html = value;
				}
				return html;
			}
		},
		{ field: 'LabOrdRate', title: '检验进度',width:50,
			formatter: function(value,row,index){
				var html="";
				if (value != ""){
					html = '<a class="editcls1" onclick="ShowLabProgress(\'' + row["BookNO"] + '\')">'+value+'</a>';
				}else{
					html = value;
				}
				return html;
			}
		},
		//核酸日期、核酸结果 扩展字段，需要在后台实现
		/*{ field: 'COVID19Date', title: '核酸日期',width:90,
			styler: function(value,row,index){
				if (row["COVID19DateColor"]){
					return 'color:'+row["COVID19DateColor"]+';';
				}
			}
		},
		{ field: 'COVID19Result', title: '核酸结果',width:130},*/
		{ field: 'OperDate', title: '手术日期',width:90},
		{ field: 'OperName', title: '手术名称',width:100,
			formatter: function(value,row,index){
				return "<span title='" + (value ? value : "") + "'>" + (value ? value : "") + "</span>";
			}
		},
		{ field: 'RegDate', title: '安排住院日期',width:100},
		{ field: 'Notes', title: '院前服务中心备注',width:150,showTip:true,tipPosition:'left'}
    ]];
	$('#PatBookListTab').datagrid({  
		fit : true,
		width : 'auto',
		autoSizeColumn:false,
		border : false,
		striped : true,
		singleSelect : false,
		//fitColumns : true,
		autoRowHeight : false,
		loadMsg : $g('加载中..'),  
		pagination : true, 
		pageSize:20,
		pageList:[20,30,40,50,200],
		rownumbers : false,
		idField:"BookNO",
		columns :Columns,
		titleNoWrap:false,
		//nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.InService.AppointManageV2&QueryName=FindAppPat",
		frozenColumns:[[
			{ field: 'BookNO', title: '操作',width:170,align:'center',
				formatter: function(value,row,index){
					var html = "";
					if (bookingOperation!="N"){
						if((row["appState"]!="Void")&&(row["appState"]!="C")){
							if (row["assesReult"] =="P"){
								html ='<a class="editcls editcls-assesPass" onclick="ShowPreAsses(\'' + row["BookNO"] + '\')">'+$g("置评")+'</a>';
							}else if(row["assesReult"] =="NotP"){
								html ='<a class="editcls editcls-assesNotPass" onclick="ShowPreAsses(\'' + row["BookNO"] + '\')">'+$g("置评")+'</a>';
							}else if(row["assesReult"] ==""){
								html ='<a class="editcls" onclick="ShowPreAsses(\'' + row["BookNO"] + '\')">'+$g("评估")+'</a>';
							}
							
							if (row["appState"]  =="Ar"){
								html = '<a class="editcls editcls-finish">'+$g("完成")+'</a>';
								html += '<a class="editcls editcls-finish">'+$g("完成")+'</a>';
							}else if(row["appState"] =="B"){
								html +='<a class="editcls editcls-assesPass" onclick="ShowPatAppointWin(\'' + row["BookNO"] + '\')">'+$g("登记")+'</a>';
							}else if(row["appState"] =="Al"){
								html +='<a class="editcls editcls-assesPass" onclick="ShowPatAppointWin(\'' + row["BookNO"] + '\')">'+$g("修改")+'</a>';
							}else if(row["appState"] ==""){
								html +='<a class="editcls" onclick="ShowPatAppointWin(\'' + row["BookNO"] + '\')">'+$g("安排")+'</a>';
							}
						}else{
							html = '<a class="editcls editcls-finish">'+$g("作废")+'</a>';
							html += '<a class="editcls editcls-finish">'+$g("作废")+'</a>';
						}
					}
					html +='<a class="editcls" onclick="ShowFlowChart(\'' + row["BookNO"] + '\')">'+$g("流程图")+'</a>';
					return html
				}
			},
			{ field: 'BookType', title: '类型',width:100},
			{ field: 'appStateDesc', title: '状态',width:55},
			{ field: 'TreatedPrinciple', title: '收治原则',width:100},
			{ field: 'RegNO', title: '登记号',width:100,sortable:true},
			{ field: 'PatName', title: '姓名',width:100,
				styler: function(value,row,index){
					if (row["InSourceDesc"] == $g("急诊")){
						return 'color:red;'
					}
				}
			},
			{ field: 'Sex', title: '性别',width:50},
			{ field: 'Age', title: '年龄',width:60},
			{ field: 'LinkManPhone', title: '联系电话',width:105}
		]],
		onBeforeLoad:function(param){
			$('#PatBookListTab').datagrid("unselectAll");
			var BookTypeArr=[];
			var selBookType=$("input[name='BookType']:checked");
			for (var i=0;i<selBookType.length;i++){
				BookTypeArr.push($(selBookType[i]).val());
			}
			var selAssessArr=[];
			var selAssess=$("input[name='Assess']:checked");
			for (var i=0;i<selAssess.length;i++){
				selAssessArr.push($(selAssess[i]).val());
			}
			var AppLoc=$('#SearchAppLoc').combobox('getValue');
			var AppWard=$('#SearchAppWard').combobox('getValue') || PageLogicObj.SelWardLocStr.join("^");
			if (isShowWardList=="N" && WARDBeforehand=="N"){
				if (!AppLoc) AppLoc=WardLinkLocId;
				if (!AppWard) AppWard=session['LOGON.CTLOCID'];
			}
			if (isShowWardList=="N" && !AppWard) AppWard="ALL";
			param = $.extend(param,{
				BookNO: "",
	            RegNO: $("#SearchRegNO").val(),
	            StartDate: $("#SearchDateFrom").datebox('getValue'),
	            EndDate: $("#SearchDateTo").datebox('getValue'),
	            AppLoc: AppLoc,
	            AppWard: AppWard,
	            AppDoc: $("#bookDocBox").combobox('getValue'),
	            PatName: $("#SearchPatName").val(),
	            AppState: $("input[name='patState']:checked").val(),
	            IllStatus: $('#admInitStateBox').combobox('getValue'),
	            InSource: $('#inSorceBox').combobox('getValue'),
	            BookTypeStr: BookTypeArr.join("^"),
	            SortType: 0,
	            HospID: session['LOGON.HOSPID'],
	            NeedRegist: "N", //needRegist 不管传入的参数是否需要登记，患者列表都需要显示为登记的患者，因为该页面可登记
	            SearchAssessResult:selAssessArr.join("^"),
			});
		},
		onDblClickHeader:function(){
			//使用以下代码定义导出或打印功能
			// CONTEXT=K类名:Query名&PAGENAME=界面代码&PREFID=0
			window.open("websys.query.customisecolumn.csp?CONTEXT=KNur.InService.AppointManageV2:FindAppPat&PAGENAME=DHCNurseAppointManageV2&PREFID=0");
		}
	})
}
function initPatSchCondition(){
    $("#SearchCardNo,#SearchRegNO,#SearchPatName").val("");
    $("#admInitStateBox").combobox('select', "");
    $("#inSorceBox,#SearchAppLoc,#SearchAppWard,#bookDocBox").combobox('select', "");
    $('#SearchDateFrom').datebox('setValue', dateCalculate(new Date(), -10));
    $('#SearchDateTo').datebox('setValue', formatDate(new Date()));
	$('#bookDocBox').combobox({
        valueField: 'ID',
        textField: 'name'
    }).combobox('clear');

    if (isShowWardList=="N"){
	    $('#SearchAppLoc').combobox({
	        valueField: 'ID',
	        textField: 'desc',
	        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID'],
	        onSelect: function(record) {
	            $('#bookDocBox').combobox('clear');
	            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getMainDoctors&locID=' + $(this).combobox("getValue");
	            $('#bookDocBox').combobox('reload');
	        },
	        onChange: function(desc, val) {
	            if (!desc && val == "") {
	                $('#bookDocBox').combobox('clear');
	                $('#bookDocBox').combobox('loadData', {}); //清空option选项   

	            }
	        },
	        filter: function(q, row) {
	            var opts = $(this).combobox('options');
	            var text = row[opts.textField]; //下拉的对应选项的汉字
	            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
	            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
	                return true;
	            }
	            return false;
	        },
	        onLoadSuccess:function(){
		        if (WARDBeforehand=="N"){
			        $('#SearchAppLoc').combobox("select",WardLinkLocId).combobox('disable');
			    }
		    }
	    });
	    $('#SearchAppWard').combobox({
	        valueField: 'ID',
	        textField: 'desc',
	        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=W&HospID=' + session['LOGON.HOSPID'],
	        filter: function(q, row) {
	            var opts = $(this).combobox('options');
	            var text = row[opts.textField]; //下拉的对应选项的汉字
	            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
	            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
	                return true;
	            }
	            return false;
	        },
	        onLoadSuccess:function(){
		        if (WARDBeforehand=="N"){
			        $('#SearchAppWard').combobox("select",session['LOGON.CTLOCID']).combobox('disable');
			    }
		    }
	    })
	}else{
		$('#SearchAppLoc').combobox({
	        valueField: 'id',
	        textField: 'desc',
	        onSelect: function(record) {
	            $('#bookDocBox').combobox('clear');
	            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getMainDoctors&locID=' + $(this).combobox("getValue");
	            $('#bookDocBox').combobox('reload');
	        },
	        onChange: function(desc, val) {
	            if (!desc && val == "") {
	                $('#bookDocBox').combobox('clear');
	                $('#bookDocBox').combobox('loadData', {}); //清空option选项   
	            }
	        },
	        filter: function(q, row) {
	            var opts = $(this).combobox('options');
	            var text = row[opts.textField]; //下拉的对应选项的汉字
	            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
	            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
	                return true;
	            }
	            return false;
	        }
	    });
	    $('#SearchAppWard').combobox({
	        valueField: 'id',
	        textField: 'desc',
	        filter: function(q, row) {
	            var opts = $(this).combobox('options');
	            var text = row[opts.textField]; //下拉的对应选项的汉字
	            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
	            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
	                return true;
	            }
	            return false;
	        }/*,
	        onLoadSuccess:function(){
		        if (WARDBeforehand=="N"){
			        $('#SearchAppWard').combobox("select",session['LOGON.CTLOCID']).combobox('disable');
			    }
		    }*/
	    })
	}
    
	//入院途经
	$('#inSorceBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getInSorces',
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
    })
	//紧急情况
	$('#admInitStateBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getAdmInitStates',
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
    })
    InitPatBookListTab();
}
function InitTip(){
	if (isShowWardList=="N"){
		var _content='<div class="tip_class">';
		var height=193;
	}else{
		var _content='<div class="tip_class"><div class="hisui-panel" title="病区字体颜色说明" style="width:250px;height:132px;">'+
				'<p style="color:green;">'+$g('绿色字体表示病区可用床位数大于10')+'</p>'+
				'<p style="color:orange;">'+$g('黄色字体表示病区可用床位数小于10')+'</p>'+
				'<p style="color:red;">'+$g('红色字体表示病区可用床位数为0')+'</p>'+
			'</div>';
		var height=335;
	}
	_content=_content+'<div class="hisui-panel" title="患者字体颜色说明" style="width:250px;height:74px;">'+
				'<p style="color:red;">'+$g('姓名红色表示患者为急诊入院')+'</p>'+
			'</div>'+
			'<div class="hisui-panel" title="病情字体颜色说明" style="width:250px;height:85px;">'+
				'<div class="illness-div" style="background:'+GetIllLevelColor("C")+';">'+$g('病危')+'</div><div class="illness-div" style="background:'+GetIllLevelColor("S")+';margin:10px 0;">'+$g('病重')+'</div><div class="illness-div" style="background:'+GetIllLevelColor("G")+';">'+$g('一般')+'</div>'+
			'</div></div>';
	$("#pagecolor-tip").popover({
		title:'页面颜色说明',
		width:270,
		height:height,
		trigger:'hover',
		offsetLeft:15,
		content:_content,
		onShow:function(){
			$('.tip_class .hisui-panel').panel({ })   
		}
	});
}
function ShowRisWorkWin(RegNo){
	websys_showModal({
		url:"dhcrisworkbench.new.csp?RegNo="+RegNo,
		title:$g('检查预约'),
		width:'98%',height:'90%',
		iconCls:'icon-w-edit'
	})
}
function ShowPatAppointWin(BookNo){
	websys_showModal({
		url:"nur.hisui.patientappointV2.csp?BookNo="+BookNo+"&needRegist="+needRegist,
		title:$g('预约登记'),
		width:'1229px',height:HISUIStyleCode=="lite"?'732px':'736px',
		iconCls:'icon-w-edit',
		CallBackFunc:function(OperType){
			websys_showModal("close");
			var index=$('#PatBookListTab').datagrid("getRowIndex",BookNo);
			if (OperType!="") findAppPatList();
			$cm({
	            ClassName: "Nur.InService.AppointManageV2",
	            MethodName: "GetIPBookAndWardInfo",
	            BookNO: BookNo
	        }, function (jsonData) {
		        var rowData=$('#AppWardListTab').datagrid("getRows");
				var WardBedSummeryObj=jsonData.WardBedSummeryObj;
				var wardID=WardBedSummeryObj.wardID;
			    var wardBedSummeryData=eval("(" + WardBedSummeryObj.wardBedSummeryData + ")");
			    var index=$('#AppWardListTab').datagrid("getRowIndex",wardID);
			    if (index >=0 ){
				    var data=rowData[index];
				    $.extend(data, wardBedSummeryData);
				    $('#AppWardListTab').datagrid('updateRow',{
						index: index,
						row:data
					});
				}
		    })
		},
		GetAppState:function(){
			return $("input[name='patState']:checked").val();
		}
	})
}
function ShowPreAsses(BookNo){
	websys_showModal({
		url:"nur.hisui.prepatassesV2.csp?BookNo="+BookNo,
		title:$g('院前评估'),
		width:'1229px',height:HISUIStyleCode=="lite"?'732px':'736px',
		iconCls:'icon-w-edit',
		CallBackFunc:function(AssessResult){
			websys_showModal("close");
			/*if (AssessResult !=""){
				var index=$('#PatBookListTab').datagrid("getRowIndex",BookNo);
				$('#PatBookListTab').datagrid('updateRow',{
					index: index,
					row: {
						assesReult: AssessResult
					}
				});
			}*/
		},
		onClose:function(){
			findAppPatList();
		},
		GetSelBookAppBedCode:function(){
			var index=$('#PatBookListTab').datagrid("getRowIndex",BookNo);
			var rows=$('#PatBookListTab').datagrid("getRows");
			return rows[index].AppBedCode;
		}
	})
}
function ShowLabProgress(BookNo){
	websys_showModal({
		url:"nur.hisui.patientpreordprogressV2.csp?BookNo="+BookNo+"&SearchOrdType=L"+"&AppStatus="+$("input[name='patState']:checked").val(),
		title:$g('检验进度'),
		width:'1229px',height:'736px',
		iconCls:'icon-w-find'
	})
}
function ShowRisProgress(BookNo){
	websys_showModal({
		url:"nur.hisui.patientpreordprogressV2.csp?BookNo="+BookNo+"&SearchOrdType=Exam"+"&AppStatus="+$("input[name='patState']:checked").val(),
		title:$g('检查进度'),
		width:'1229px',height:'736px',
		iconCls:'icon-w-find'
	})
}
function ShowFlowChart(BookNo){
	websys_showModal({
		url:"nur.hisui.patientpreordprogressV2.csp?BookNo="+BookNo+"&SearchOrdType=Flow"+"&AppStatus="+$("input[name='patState']:checked").val(),
		title:$g('流程图'),
		width:'1229px',height:'402px',
		iconCls:'icon-w-eye'
	})
}
function GetIllLevelColor(code){
	var index=$.hisui.indexOfArray(IllLevelColorJson,"IllLevelCode",code);
	if (index >=0 ){
		return IllLevelColorJson[index]["IllLevelColor"];
	}
	return '';
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function exportBtnClick(){
	$('#PatBookListTab').datagrid("unselectAll");
	var BookTypeArr=[];
	var selBookType=$("input[name='BookType']:checked");
	for (var i=0;i<selBookType.length;i++){
		BookTypeArr.push($(selBookType[i]).val());
	}
	var selAssessArr=[],selAssessDesc=[];
	var selAssess=$("input[name='Assess']:checked");
	for (var i=0;i<selAssess.length;i++){
		selAssessArr.push($(selAssess[i]).val());
		selAssessDesc.push($(selAssess[i]).attr("label"));
	}
	var StartDate=$("#SearchDateFrom").datebox('getValue');
    var EndDate=$("#SearchDateTo").datebox('getValue');
	var patStateDesc=$("input[name='patState']:checked").attr("label");
	 $.cm({
	     ExcelName:"住院证"+StartDate+"至"+EndDate+patStateDesc+selAssessDesc.join("、")+"患者查找单",
	     PageName:"DHCNurseAppointManageV2",
	     ResultSetType:"ExcelPlugin",
	     ClassName : "Nur.InService.AppointManageV2",
	     QueryName : "FindAppPat",
	     BookNO: "",
         RegNO: $("#SearchRegNO").val(),
         StartDate: StartDate,
         EndDate: EndDate,
         AppLoc: $('#SearchAppLoc').combobox('getValue'),
         AppWard: $('#SearchAppWard').combobox('getValue') || PageLogicObj.SelWardLocStr.join("^"),
         AppDoc: $("#bookDocBox").combobox('getValue'),
         PatName: $("#SearchPatName").val(),
         AppState: $("input[name='patState']:checked").val(),
         IllStatus: $('#admInitStateBox').combobox('getValue'),
         InSource: $('#inSorceBox').combobox('getValue'),
         BookTypeStr: BookTypeArr.join("^"),
         SortType: 0,
         HospID: session['LOGON.HOSPID'],
         NeedRegist: "N", //needRegist 不管传入的参数是否需要登记，患者列表都需要显示为登记的患者，因为该页面可登记
         SearchAssessResult:selAssessArr.join("^"),
	     rows:9999999
	 },false);
}