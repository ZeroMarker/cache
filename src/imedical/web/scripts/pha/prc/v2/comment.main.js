/**
 * 名称:	 处方点评-点评处方
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-14
 */

//document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
//document.write("</object>");
PHA_COM.App.Csp = "pha.prc.v2.comment.main.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = gLoadWayID ;		//加载点评单对应的点评方式
var loadPcntId = gLoadPCntId ;
var loadWayCode = "" ;				//点评方式代码
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;
var colWidth = 20 ;
var hiddenFlag = true ;
var selResult = ""		//点评结果
var selPhaUserId = ""	//点评药师
$(function () {
	PatInfo = {
        pcntItm: 0,
        prescNo: 0,
        patNo: 0,
        patName: 0 ,
        patientID: 0,
		episodeID: 0,
        orditem: 0,
        zcyflag: 0
    };
	InitDict();
	InitSetDefVal();
	InitSetPatInfo();
	InitGridMain();
	InitGridDiag();
    InitGridPrescInfo();
    InitGridLog();   
    InitGridFindNo();
	InitReasonTreeGrid() ;		// 在选取点评单后调用
	InitGridLinkOrd();
    InitGridQuestion();
    $("#btnFind").on("click", function () {
		ShowDiagFindNo(this)
	});
	$("#btnSearch").on("click", function () {
		SearchComments()
	});
	$("#btnSelect").on("click", function () {
		SelectCommentItms() ;
	});
	$("#btnDelete").on("click", function () {
		DeleteComment() ;
	});
	$("#btnSubmit").on("click", function () {
		SubmitComment() ;
	});
	//点评通过(合理)
	$("#btnPass").on("click", function () {
		CommentOK() ;
	});
	//点评不通过(不合理)
	$("#btnRefuse").on("click", function () {
		//CommentBad()
		ShowDiagUnreason(this) ;
	});
	//点评不通过(不合理)
	$("#btnAnaly").on("click", function () {
		PrescAnalyse() ;
	});
	//保存点评不合理原因等信息
	$("#btnSave").on("click", function () {
		saveReason() ;
	});
	
	$("#tabsForm").tabs({
        onSelect: function(title) {
		    // 这不常用,每次tk下没事
		    var admData=tkMakeServerCall("web.DHCSTPIVAS.Common","GetAdmInfo",EpisodeId);
		    var patId=admData.toString().split("^")[0]||"";
			
			var gridSelect = $("#gridMain").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('提示',"请先选中需要查看的处方!","info");
				return;
			}
			var prescNo = gridSelect.prescNo ;
			var cyflag = gridSelect.zcyflag ;	
			var EpisodeId = gridSelect.adm ;	
			var patId = gridSelect.papmi ;
			//alert("EpisodeId:"+EpisodeId)
			
			if (title=="处方预览"){
		        if ($('#ifrmPresc').attr('src')==""||"undefined"){
			        var prescno=prescNo ;
			        var cyflag=cyflag ;
					var phartype="DHCOUTPHA";
					var paramsstr=phartype+"^"+prescno+"^"+cyflag;
		            $("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");
		        } 
		    }
	        else if (title=="病历浏览"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ patId + '&EpisodeID=' + EpisodeId + '&EpisodeLocID=' + logonLocId );
		        } 
		    }else if (title=="过敏记录"){
			    if ($('#ifrmAllergy').attr('src')==""||"undefined"){
					$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId); 
			    }
			}else if (title=="检查记录"){
				if ($('#ifrmRisQuery').attr('src')==""||"undefined"){
					$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);
				}
			}else if (title=="检验记录"){
				if ($('#ifrmLisQuery').attr('src')==""||"undefined"){
					$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId); 
				}
			}else if (title=="本次医嘱"){
				if ($('#ifrmOrdQuery').attr('src')==""||"undefined"){
					//$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
					$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + patId+'&EpisodeID=' + EpisodeId+'&mradm=' + EpisodeId+'&OpenWinName=OPDocRecAdm');
					//$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?EpisodeID=' + EpisodeId);
				} 
			}
        }
    });

});

// 字典
function InitDict() {
	// 初始化-日期
	PHA.DateBox("conStartDate", {});
	PHA.DateBox("conEndDate", {});
	// 初始化点评方式
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay("1","CNTS").url,
		width:140
	});
	// 初始化点评结果 1-仅有结果,2-仅无结果,3-仅合理,4-仅不合理,5-仅医生申诉
	PHA.ComboBox("conResult", {
		data: [{
			RowId: "1",
			Description: "仅有结果"
		}, {
			RowId: "2",
			Description: "仅无结果"
		}, {
			RowId: "3",
			Description: "仅合理"
		}, {
			RowId: "4",
			Description: "仅不合理"
		}, {
			RowId: "5",
			Description: "仅医生申诉"
		}],
		panelHeight: "auto",
		width:160
	});
	//初始化点评药师
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
	// 初始化点评状态
	PHA.ComboBox("comState", {
		data: [{
			RowId: "1",
			Description: "未点评"
		}, {
			RowId: "2",
			Description: "点评中"
		}, {
			RowId: "3",
			Description: "点评完成"
		}, {
			RowId: "4",
			Description: "已提交"
		}],
		panelHeight: "auto",
		width:140
	});
	PHA.ComboBox("conWarn", {
		url: PRC_STORE.Factor(),
		width:333
	});
	PHA.ComboBox("conAdvice", {
		url: PRC_STORE.PhaAdvice(),
		width:333
	});
}

/// 界面信息初始化
function InitSetDefVal() {
	//界面配置
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.ComEndDate);
		// 二次点评启用标志
		if (jsonColData.ReCntFlag == "Y")
		{
			width = 0 ;
			hiddenFlag = false ;
		}
		if (jsonColData.DefaultLogonUser == "Y")
		{
			var phaFlag=tkMakeServerCall("PHA.PRC.Com.Util","ChkPharmacistFlag",logonUserId)
			if (phaFlag=="Y"){	//仅当登录人为已维护的药师时才默认
				$("#conPharmacist").combobox("setValue", logonUserId);
			}
		}
		//初始化中有是否启用二次点评标志，异步问题，初始化处方列表放这
		//InitGridMain(); 
		
	});
	
	
}

function InitSetPatInfo(){	
	var imageid="icon-unmale.png";
	var emptyMsg="请先选择一个处方"		
	var pathtml=""
	pathtml+='<div style="position: absolute;top: 0px;left: 0px;">'
		pathtml+='<img src=/imedical/web/scripts/pharmacy/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">';
	pathtml+='</div>';	
	pathtml+='<div style="margin-top:17px;padding-left:35px">'
		pathtml+='<div style="line-height:25px">';
			pathtml+='<span style="font-size:14px;color:#666666">'+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+emptyMsg+'</span>'
		pathtml+='</div>';
	pathtml+='</div>';
	$("#dhcpha-patinfo").append(pathtml);
	
}


// 表格-点评处方
function InitGridMain() {
    var columns = [
        [
            { field: "analysisResult", index:'analysisResult' , title: '合理用药',width: 70+colWidth,formatter: druguseFormatter },
            { field: 'passtext', title: '预审', width: 100, hidden: true},
            { field: "patNo", title: '登记号' ,width: 120, hidden: true},
            { field: "patName", title: '姓名', width: 100, hidden: true },
            { field: "sexDesc", title: '性别',width: 120, hidden: true},
            { field: 'patAge', title: '年龄', width: 200, hidden: true},
            { field: "typeDesc", title: '费别' ,width: 120, hidden: true},
            { field: "diag", title: '诊断',width: 100, hidden: true },
            { field: "prescNo", index:'prescNo', title: '处方号',width: 120+colWidth },
            { field: 'curret', title: '点评结果', width: 100+colWidth},
            { field: 'oriCurret', title: '初评结果', width: 80, hidden: hiddenFlag},
			{ field: "docName", title: '医生' ,width: 120, hidden: true},
            { field: "doclocDesc", title: '科室' ,width: 120, hidden: true},
            { field: "adm", title: 'adm',width: 120 , hidden: true},
            { field: 'orditm', index:'orditm', title: 'orditm', width: 200, hidden: true},
            //{ field: "porcess", title: 'porcess' ,width: 120, hidden: true},
            { field: "wayCode", title: 'waycode', width: 100, hidden: true },
            { field: "pcntItm", title: '点评明细id',width: 120, hidden: true},
            { field: 'zcyflag', title: 'zcyflag', width: 200, hidden: true},
            { field: "analyResultRet", index:'分析结果值', title: 'analyResultRet' ,width: 120, hidden: true},
            { field: "analysisData", index:'分析结果', title: 'analysisData' ,width: 120, hidden: true},
            { field: "manLevel", index:'控制等级', title: 'manLevel' ,width: 120, hidden: true},
            { field: "papmi", title: 'papmi',width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentItms',
            pcntId: loadPcntId ,
            comResult: selResult,
            phaUserId: selPhaUserId
            
        },
        columns: columns,
        toolbar: "#gridMainBar",
        onClickRow:function(rowIndex,rowData){
			//$("#dhcpha-patinfo").append("");
			$("#dhcpha-patinfo").empty();
			var patordinfo='';
			var pcntItm = rowData.pcntItm ;
			var prescNo = rowData.prescNo ;
			var patNo = rowData.patNo ;
			var patName = rowData.patName ;
			var sexDesc = rowData.sexDesc ;
			var patAge = rowData.patAge ;
			var adm = rowData.adm ;
			var papmi = rowData.papmi ;
			var orditm = rowData.orditm ;
			var zcyflag = rowData.zcyflag ;
			var typeDesc = rowData.typeDesc ;		//患者费别
			var doclocDesc = rowData.doclocDesc ;	//就诊科室
			var patDiag = "诊断："+rowData.diag ;			//患者诊断
			//HLYYPreseCheck(prescNo,1) ;
			var imageid="";
			if (sexDesc=="女"){  //非女即男
				imageid="icon-female.png";
			}else if (sexDesc=="男"){
				imageid="icon-male.png";
			}else{
				imageid="icon-unmale.png";
			}
						
			patordinfo='<span>'+prescNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+patNo+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+sexDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+patAge+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+typeDesc+'&nbsp;&nbsp;</span>'+'<span style="color:#CCCCCC">'+"/"+'</span>'+'&nbsp;&nbsp;';
			patordinfo=patordinfo+'<span>'+doclocDesc+'&nbsp;&nbsp;</span>'+'&nbsp;&nbsp;';
			
			var pathtml=""
			pathtml+='<div style="position: absolute;top: 0px;left: 0px;">'
				pathtml+='<img src=/imedical/web/scripts/pharmacy/images/'+imageid+' style="border-radius:35px;height:50px;width:50px;">';
			pathtml+='</div>';	
			pathtml+='<div style="padding-left:60px">'
				pathtml+='<div style="line-height:25px;padding-top:0px">';
					pathtml+='<span style="font-size:14px;">'+patName+'&nbsp;&nbsp;&nbsp;</span>'+patordinfo;
				pathtml+='</div>';
				pathtml+='<div style="line-height:25px">';
					pathtml+='<span>'+patDiag+'</span>'
				pathtml+='</div>';
			pathtml+='</div>';
			pathtml+='</div>';
			
			$("#dhcpha-patinfo").append(pathtml);
			$("#patDiag").tooltip({
		        content: $("#patDiag").text(),
		        position: 'bottom',
		        showDelay: 500
		    });
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//医嘱明细
				QueryPrescDetail() ;
				QueryLogDetail() ;			
			}else if (index==1){	//处方预览
				var prescno=prescNo ;
				var cyflag=zcyflag ;
				var phartype="DHCOUTPHA";
				var paramsstr=phartype+"^"+prescno+"^"+cyflag;
				$("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW");			
			}else if (index==2){	//过敏记录
				$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + adm+'&PatientID='+papmi);		
			}else if (index==3){	//检查记录
				$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + adm+'&PatientID='+papmi);			
			}else if (index==4){	//检验记录
				$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + adm+'&NoReaded='+'1'+'&PatientID='+papmi);			
			}else if (index==5){	//病历浏览
				 $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ papmi + '&EpisodeID=' + adm + '&EpisodeLocID=' + logonLocId );			
			}else if (index==6){	//本次医嘱
				//$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + adm+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
				$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + papmi+'&EpisodeID=' + adm+'&mradm=' + adm+'&OpenWinName=OPDocRecAdm');
		
			}
		},
		onRowContextMenu: rightClickCommentFn,
		onClickCell: function (rowIndex, field, value) {
			var rows = $(this).datagrid('getRows');
			var rowData = rows[rowIndex];
            if (field != "analysisResult") {
                return
            }
            var content = rowData.analysisData;
            DHCSTPHCMPASS.HUIAnalysisTips({
                Content: content
            })
        }	
			
    };
    PHA.Grid("gridMain", dataGridOption);
}

//重新load Tab,并加载数据
var HrefRefresh = function() {
    var adm = PatInfo.adm;
    var patientID = PatInfo.patientID;
    var episodeID = PatInfo.episodeID;
    var prescno = PatInfo.prescno;
    var orditem = PatInfo.orditem;
    var zcyflag = PatInfo.zcyflag;
	
    var p = Ext.getCmp("ToolsTabPanel").getActiveTab();
    var iframe = p.el.dom.getElementsByTagName("iframe")[0];

    if (p.id == "framepaallergy") {
        iframe.src = 'dhcem.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framerisquery") {
        iframe.src = ' dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framelabquery") {
        iframe.src = 'dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1';
    }

    if (p.id == "frameprbrowser") {
        //iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
        var LocID = session['LOGON.CTLOCID'];
        //iframe.src = p.src + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
        iframe.src = 'emr.browse.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
    }


    //明细
    if (p.id == "frameordquery") {
        if (adm == 0) return;
        FindDiagData(adm);
        FindOrdDetailData(prescno);
        FindLogData(orditem);
        CheckArcExist(prescno);
    }

    //处方预览
    if (p.id == "prescriptioninfo") {
        if (zcyflag == 0) {
            iframe.src = 'dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        } else {
            iframe.src = 'dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        }
    }

    //本次医嘱
    if (p.id == "frameadmordquery") {
        //iframe.src = p.src + '?EpisodeID=' + adm;
        iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
    }
};

function InitGridDiag() {
    var columns = [
        [
            { field: "diag", title: '诊断',width: 620, }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectDiagList',
			adm: ''
        },
        columns: columns,
        pagination: false  
    };
    PHA.Grid("gridDiag", dataGridOption);
}

function InitGridPrescInfo() {
    var columns = [
        [
            { field: "arcitmdesc", title: '医嘱名称',width: 200 },
            { field: "qty", title: '数量',width: 80 },
            { field: "uomdesc", title: '单位',width: 80 },
            { field: "dosage", title: '剂量',width: 120 },
            { field: "freq", title: '频次',width: 120 },
            //{ field: "spec", title: '规格',width: 120 },		医嘱结果改造之后医嘱项不能确定唯一的规格
            { field: "instruc", title: '用法',width: 120 },
            { field: "duration", title: '用药疗程',width: 120 },
            { field: "realdura", title: '实用疗程',width: 80 },
            //{ field: "form", title: '剂型',width: 120 },
            { field: "basflag", title: '基本药物',width: 80 },
            { field: "doctor", title: '医生',width: 120 },
            { field: "orddate", title: '医嘱开单日期',width: 120 },
            { field: "remark", title: '医嘱备注',width: 120 },
            //{ field: "manf", title: '厂家',width: 120 },
            { field: "orditm", title: 'orditm',width: 120,hidden:true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectPrescDetail',
			prescNo: ''
        },
        pagination:false,
        pageSize:100,
        columns: columns,
        toolbar: [], //"#gridPrescInfotableBar",
        onClickRow:function(rowIndex,rowData){
	        if (rowData){
		        
			}   
		},
		onRowContextMenu: rightClickYDTSFn
    };
    PHA.Grid("gridPrescInfo", dataGridOption);
}

function InitGridLog() {
    var columns = [
        [
            { field: "grpNo", title: '组号',width: 50, },
            { field: "reasonDesc", title: '点评原因',width: 300,
            	formatter:function(v){
					return v.replace('└──','<span style="color:#999999">└──</span>')
				} 
			},
            { field: "patName", title: '姓名',width: 120, hidden: true },
            { field: "prescNo", title: '处方号',width: 120, hidden: true },
            { field: "comDate", title: '点评日期',width: 120, },
            { field: "comTime", title: '点评时间',width: 120, },
            { field: "comUserName", title: '点评人',width: 120, },
            { field: "comResult", title: '点评结果',width: 120, },
            { field: "factorDesc", title: '不合格警示值',width: 120, },
            { field: "adviceDesc", title: '药师建议',width: 120, },
            { field: "phaNote", title: '药师备注',width: 120, },
            { field: "docAdvice", title: '医生反馈',width: 120, hidden:true},
            { field: "docNote", title: '医生备注',width: 120, },
            { field: "reSaveFlag", title: '二次点评',width: 70, },
            { field: "active", title: '有效',width: 60, }
            
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentLog' ,
			pcntItm: ''
        },
        columns: columns,
        toolbar:[],
        pagination: false 
		//fitColumns: true 
		//shrinkToFit:false
		  
    };
    PHA.Grid("gridLog", dataGridOption);
}

// 表格-点评单
function InitGridFindNo() {
    var columns = [
        [
            { field: "pcntId", title: 'rowid', width: 80, hidden:true},
            { field: "pcntNo", title: '单号',width: 150 },
            { field: 'pcntDate', title: '日期', width: 100},
            { field: "pcntTime", title: '时间', width: 80 },
            { field: "pcntUserName", title: '制单人' ,width: 80},
            { field: "typeDesc", title: '类型',width: 120 },
            { field: 'wayDesc', title: '方式', width: 150},
            { field: "pcntText", title: '查询条件' ,width: 400},
            { field: "pcntState", title: '点评状态',width: 80 },
            { field: 'pcntWayCode', title: '方式代码', width: 200, hidden: true},
			{ field: 'pcntWayId', title: '方式', width: 200, hidden: true}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: '1',
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '',
			logonLocId: logonLocId,
			searchFlag: ''
        },      
        columns: columns,
        toolbar: "#gridFindNoBar",
        border: true ,
        bodyCls:'panel-header-gray',
        onDblClickRow:function(rowIndex,rowData){
	         SelectCommentItms() ;
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

//************************* 选取点评原因界面数据初始化 Start *****************************

function InitReasonTreeGrid() {
	PHA.Tree("gridReason",{})
	$.cm({
		ClassName: 'PHA.PRC.Com.Store',
		MethodName: 'GetPRCReasonTree',
		wayId: loadWayId , 
		ParentId: ''
	},function(data){
		$('#gridReason').tree({
			lines: false,
			data: data			
		});
		
	});

}

/// 点评原因树双击事件
$('#gridReason').tree({
	onDblClick: function(node){
		treeClickEvent(node) ;		
	}
});

//初始化表格-原因关联医嘱
function InitGridLinkOrd() {
    var columns = [
        [
            { field: "ordDesc", title: '医嘱名称',width: 270, },
            { field: "orditm", title: 'orditm', width: 80, hidden : true },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectOrdDetail',
			input :''
        },
        columns: columns,
        pagination: false,
        onDblClickRow:function(rowIndex,rowData){
			var orditm = rowData.orditm ;
			var ordDesc = rowData.ordDesc ;
			OrderClickEvent(orditm, ordDesc) ;
		}   
    };
    PHA.Grid("gridLinkOrder", dataGridOption);
}

//初始化表格-问题列表
function InitGridQuestion() {
    var columns = [
        [
            { field: "desc", title: '描述', width: 300,
            formatter:function(v){
					return v.replace('└──','<span style="color:#999999">└──</span>')
				}  },			
            { field: "level", title: '分级', width: 80 },
			{ field: "rowid", title: 'rowid', width:100, hidden:true} 
        ]
    ];
    var dataGridOption = {
       // url: $URL,
        //queryParams: {
       //     ClassName: '',
       //     QueryName: ''
       // },
        columns: columns,
        pagination: false,
        toolbar: "#gridQuestionBar",
        onDblClickRow:function(rowIndex,rowData){
			$('#gridQuestion').datagrid('deleteRow', rowIndex);
		}   
    };
    PHA.Grid("gridQuestion", dataGridOption);
}



//************************* 选取点评原因界面数据初始化 End *****************************

//**************************** 点评界面弹框 Start ***********************
/// 打开查单界面
function ShowDiagFindNo(btnOpt) {
	$('#diagFindNo').dialog({
		title: "点评处方" + btnOpt.text,
		iconCls:  'icon-w-find', 
		modal: true
	})
	$('#diagFindNo').dialog('open');
	
}

/// 打开关联不合理原因和医嘱界面
function ShowDiagUnreason(btnOpt) {
	
	ClearQuestionGrid() ;
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的处方!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//点评结果
	/*
	if (pItmResult.indexOf("接受")>0){
		$.messager.alert('提示',"该处方为已接受状态，不允许再次点评!","info");
		return;
	}
	*/
	var pcntsItmId = gridSelect.pcntItm ;		//点评子表id
	var pcntsAuth = tkMakeServerCall("PHA.PRC.Create.Main","ChkItmComAuth",longoninfo,pcntsItmId)			//获取点评权限
	if (pcntsAuth !== "1"){
		var pcntsAuthData = pcntsAuth.split("^")
		$.messager.alert('提示',pcntsAuthData[1],"info");
		return;
	}
	
	$('#diagSelectReason').dialog({
		title: "不合理原因" ,
		iconCls:  'icon-w-list' ,
		modal: true
	})
	$('#diagSelectReason').dialog('open');
	
	var prescNo = gridSelect.prescNo;
	
	$('#gridLinkOrder').datagrid('query', {
        input: prescNo
    });
	
}

//**************************** 点评界面弹框 End ***********************

// ***********************界面调用方法 Start ************************
function QueryDiag(){
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var adm=gridSelect.adm;

    $('#gridDiag').datagrid('query', {
        adm: adm
    });
	

}

///获取处方明细信息
function QueryPrescDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var prescNo=gridSelect.prescNo;

    $('#gridPrescInfo').datagrid('query', {
        prescNo: prescNo
    });
}

///获取点评日志信息
function QueryLogDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var pcntItm=gridSelect.pcntItm;

    $('#gridLog').datagrid('query', {
        pcntItm: pcntItm
    });
}

/// 查询点评单
function SearchComments(){
	var stDate = $("#conStartDate").datebox('getValue') ;
	var endDate = $("#conEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#comState").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state
	
	$("#gridFindNo").datagrid("query", {
		findFlag: '1',
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});
		
}

/// 选取点评单信息
function SelectCommentItms(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
		loadPcntId = pcntId
		loadWayId = gridSelect.pcntWayId ;
		loadWayCode = gridSelect.pcntWayCode ;
		selResult = $("#conResult").combobox('getValue')||'';
		selPhaUserId = $("#conPharmacist").combobox('getValue')||'';
	if (loadWayCode == "RE"){
		hiddenFlag = false ;
		colWidth = 0 ;
		$('#btnPass').linkbutton({text:'通过'});
		$('#btnRefuse').linkbutton({text:'不通过'});
	}
	else {
		hiddenFlag = true ;
		colWidth = 20 ;
		$('#btnPass').linkbutton({text:'合格'});
		$('#btnRefuse').linkbutton({text:'不合格'});
	}
		InitGridMain();
	$('#diagFindNo').dialog('close');
	ClearCommentGrid() ;
	InitReasonTreeGrid() ;		//选取完点评单后才能获取到点评方式Id
}

/// 删除点评单
function DeleteComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	var delInfo = "您确认删除吗?"
	PHA.Confirm("删除提示", delInfo, function () {
		var deleteRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'DeleteComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
	
		var deleteRet = deleteRet.toString() ;
		var deleteArr = deleteRet.split('^');
		var deleteVal = deleteArr[0];
		var deleteInfo = deleteArr[1];
		
		if (deleteVal < 0) {
			PHA.Alert('提示', deleteInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
	
}

/// 提交点评单
function SubmitComment(){
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var pcntId=gridSelect.pcntId;
	if (pcntId==''){
		$.messager.alert('提示',"没有获取到点评单Id，请重新选择后重试!","info");
		return;
	}
	var logonInfo = logonGrpId + "^" + logonLocId + "^" + logonUserId  ;
	var subInfo = "您确认提交吗?提交后不允许取消提交！"
	PHA.Confirm("提交提示", subInfo, function () {
		var submitRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SubmitComment',
			pcntId: pcntId,
			logonInfo: logonInfo,
			dataType: 'text'
		}, false);
		
		var submitRet = submitRet.toString() ;
		var submitArr = submitRet.split('^');
		var submitVal = submitArr[0];
		var submitInfo = submitArr[1];
		
		if (submitVal < 0) {
			//PHA.Alert('提示', submitVal+"^"+submitInfo, 'warning');
			PHA.Alert('提示', submitInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '提交成功',
				type: 'success'
			});
			$("#gridFindNo").datagrid("reload");
		}
	})
	
}

function CommentOK()
{
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的处方!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//点评结果
	/*
	if (pItmResult.indexOf("接受")>0){
		$.messager.alert('提示',"该处方为已接受状态，不允许再次点评!","info");
		return;
	}
	*/
	var pcntItm = gridSelect.pcntItm ;		//点评明细表id
	var result = "Y"
	var reasonstr = ""
	var input = ""
	
	SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;

}

function treeClickEvent(node)
{
	if (node.isLeaf=="N"){
		var reasonId = node.id ;  	
		var reasonDesc = node.text ;
		if (reasonId==""){
			return;
		}
		
		var gridChanges = $('#gridQuestion').datagrid('getChanges');
		var gridChangeLen = gridChanges.length;
		for (var counter = 0; counter < gridChangeLen; counter++) {
			var quesData = gridChanges[counter];
			var selReasonId = quesData.rowid|| "" ;
			
			if (selReasonId==reasonId){
				PHA.Alert('提示', '该原因已存在,不能重复添加', 'warning');
				return;		
			}		
	
		}
		$("#gridQuestion").datagrid('appendRow', {
				desc : reasonDesc ,
				level : '' ,
				rowid : reasonId
			});
			
	}

}

function OrderClickEvent(selOrdItm, selOrdDesc)
{
	if (selOrdItm==""){
		return;
	}
	var gridChanges = $('#gridQuestion').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen=="0"){		
		PHA.Alert('提示', '请先双击选择不合理原因,然后再重试！', 'warning');
		return;
	}
	var reasonRowId = ""	// 原因Id
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selRowid = quesData.rowid|| "" ;
		if (selOrdItm==selRowid){
			PHA.Alert('提示', '该医嘱已存在,不能重复添加', 'warning');
			return;		
		}		
	}
	lastData = gridChanges[(gridChangeLen-1)]
	var lastRowId = lastData.rowid|| "" ;
	//alert("selOrdItm:"+selOrdItm)
	var selOrdDesc =  "└──&nbsp;&nbsp;"+selOrdDesc
	$("#gridQuestion").datagrid('appendRow', {
			desc : selOrdDesc ,
			level :  selOrdItm ,	//lastRowId,
			rowid : selOrdItm
		});	
	

}

function saveReason()
{
	var gridChanges = $('#gridQuestion').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	//alert("gridChangeLen:"+gridChangeLen)
	if (gridChangeLen=="0"){		
		PHA.Alert('提示', '请在问题列表中加入相关联的医嘱,然后再重试！', 'warning');
		return;
	}
	var reasonIdStr = ""
	var levelflag = 0; chkexistflag=0;
	for (var counter = 0; counter < gridChangeLen; counter++) {
		var quesData = gridChanges[counter];
		var selReasonId = quesData.rowid|| "" ;
		var selLevel = quesData.level|| "" ;
		var selDesc = quesData.desc|| "" ;
		var selDescData = selDesc.split("└──")
		var selDescVal = selDescData[1]
		if (selLevel != ""){
			if (reasonIdStr==""){
				PHA.Alert('提示', '请先添加'+selDescVal+' 对应的不合理原因,然后再重试！', 'warning');
				return;	
			}
			reasonIdStr=reasonIdStr+"$$$"+selReasonId ;
		    levelflag=1;
		    chkexistflag=1;						
		}
		else {
			if (reasonIdStr == ""){
				reasonIdStr = selReasonId ;				
			}
			else {
				if (levelflag == 1){
					reasonIdStr=reasonIdStr+"!"+selReasonId ;
		  			levelflag=0;
				}
				else {
					reasonIdStr=reasonIdStr+"^"+selReasonId ;				
				}
			}
			
		}
	}	
	if (chkexistflag==0){
		PHA.Alert('提示', '请在问题列表中加入相关联的医嘱,然后再重试！', 'warning');
		return;
	}	
	var factorId = $("#conWarn").combobox('getValue')||'';		//警示值
	var adviceId = $("#conAdvice").combobox('getValue')||''; 		//建议	
	var phnoteDesc = $.trim($("#conPhNote").val());				//备注
	
	var remarkStr = factorId+"^"+adviceId+"^"+phnoteDesc ;	
	
	//$('#diagSelectReason').dialog('close');
	
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的处方!","info");
		return;
	}
	var pcntItm = gridSelect.pcntItm ;		//点评明细表id
	var result = "N"
	
	SaveCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr) ;

}

function SaveCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr){
	var OKRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SaveComItmResult',
			pcntItm: pcntItm,
			result: result,
			longoninfo: longoninfo,
			reasonstr: reasonIdStr,
			input: remarkStr ,		
			dataType: 'text'
		}, false);
		
	var RetArr = OKRet.split('^');
	var RetVal = RetArr[0];
	var RetInfo = RetArr[1];	
	if (RetVal < 0) {
		PHA.Alert('提示', RetInfo, 'warning');
		return;
	} else {
		//$("#gridMain").datagrid("reload");
		$('#diagSelectReason').dialog('close');
		var gridSelect = $("#gridMain").datagrid("getSelected");
		var seqNo = $('#gridMain').datagrid('getRowIndex',gridSelect);
		if (result=="Y"){
			if (loadWayCode == "RE"){
				var ResultDesc = "通过"	
			}
			else {
				var ResultDesc = "合格"
			}	
		}
		else if (result=="N"){
			if (loadWayCode == "RE"){
				var ResultDesc = "不通过"	
			}
			else {
				var ResultDesc = "不合格"
			}	
		}
		else{
			var ResultDesc = ""			
		}
		
		$("#gridMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		})
	}
	
	ClearCommentGrid() ;

}

/// 右键一键点评
function rightClickCommentFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //阻止向上冒泡
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_comment' + ' data-options="' + "iconCls:'icon-export-all'" + '">一键点评</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_comment").on("click", function () {
		AllCommontOk();
	})
}

function AllCommontOk(){
	var rows = $("#gridMain").datagrid("getRows");
	for (var i = 0; i < rows.length; i++) {
		var analyResultRet = rows[i].analyResultRet;
		if (analyResultRet==0){
			var pcntItm = gridSelect.pcntItm ;		//点评明细表id
			var result = "Y"
			var reasonstr = ""
			var input = ""

            SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;		
		}
	}
	$("#gridMain").datagrid("reload");
}

function ClearCommentGrid(){
	//$("#dhcpha-patinfo").empty();
	InitSetPatInfo() ;
	$("#gridPrescInfo").datagrid("clear");
	$("#gridLog").datagrid("clear");
}

function ClearQuestionGrid(){
	InitReasonTreeGrid() ;
	$("#gridQuestion").datagrid("clear");
	$("#conWarn").combobox("setValue",'');
	$("#conWarn").combobox("setText", '');
	$("#conAdvice").combobox("setValue",'');
	$("#conAdvice").combobox("setText", '');
	$("#conPhNote").val('');
	
}

//处方分析
function PrescAnalyse(){
	var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
	if (passTypeInfo==""){
		$.messager.alert('注意',"未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商!","info");
		return;
	}
	//alert("passType:"+passType)
	var passTypeData=passTypeInfo.split("^")
	var passType=passTypeData[0]
	if (passType=="DHC"){
		// 东华知识库
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "gridMain", 
		 	MOeori: "orditm",
		 	PrescNo:"prescNo", 
		 	GridType: "EasyUI", 
		 	Field: "analysisResult",
		 	ResultField:"analysisData",
		 	manLevelFleld:"analyResultRet",
		 	ManLevel: "manLevel"
		 });
	}else if (passType=="DT"){
		// 大通
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// 美康
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}

/********************** 调用大通合理用药 start   **************************/
// 初始化
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

//大通处方分析
function DaTongPrescAnalyse() {
    var rows = $("#gridMain").datagrid("getRows");
    if (rows.length == 0) {
		PHA.Alert('提示', "没有需要分析的数据！", 'warning');
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescNo;
        var analyResultRet = rows[i].analyResultRet;
        var baseinfo = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDocBaseInfoByPresc", prescno);
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescInfoXML", prescno);
        myrtn = dtywzxUI(6, baseinfo, myPrescXML);
        if (myrtn == 0) { var imgname = "warning0.gif"; }
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// 黑灯
	
		var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridMain").datagrid('updateRow', {
			index: i,
			row: {
				analysisResult: str,
				analyResultRet: myrtn
			}
		})

    }
}

// 大通药典提示
function rightClickYDTSFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //阻止向上冒泡
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_YDTS' + ' data-options="' + "iconCls:'icon-tip'" + '">药典提示</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_YDTS").on("click", function () {

		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if (passType==""){
			PHA.Alert("提示","未设置药典接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商",'warning');
			return;
		}
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			// 东华知识库
			var ordSelect = $("#gridPrescInfo").datagrid("getSelected");
			if((ordSelect=="")||(ordSelect==null)){
				PHA.Alert("提示","请先选择需要查看药典提示的明细记录!",'warning');
				return;
			}
			var userInfo = logonUserId + "^" + logonLocId + "^" + logonGrpId;
			var incDesc = ordSelect.arcitmdesc;
			var selOrdItm = ordSelect.orditm
				//alert("userInfo:"+userInfo)
				//alert("incDesc:"+incDesc)
				//alert("selOrdItm:"+selOrdItm)
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="DT"){
			// 大通
			// StartDaTongDll(); 
			// DaTongPrescAnalyse();  
		}else if (passType=="MK"){
			// 美康
			MKPrescYDTS(selOrdItm); 
		}else if (passType=="YY"){
		}		
		// 暂不放开
		return;	  

		var gridSelect = $("#gridPrescInfo").datagrid("getSelected");
		if (gridSelect==null){
			$.messager.alert('提示',"请先选中需要查看的医嘱信息!","info");
			return;
		}
		var orditm = gridSelect.orditm ;
		dtywzxUI(3, 0, "");
		var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);
		myrtn = dtywzxUI(12, 0, myPrescXML);
	})
}
/********************** 调用大通合理用药 end   **************************/


    
/********************** 调用美康合理用药 start   **************************/
//美康处方分析
function MKPrescAnalyse() {
    var rows = $("#gridMain").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescNo;
		
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = "warningnull.gif"
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// 合理
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridMain").datagrid('updateRow', {
			index: i,
			row: {
				analysisResult: str,
				analyResultRet: myrtn
			}
		})
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        }
        else {
            //alert("没问题");
        }

	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	
	
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = OrderArr[15];                //药品开出数量
        drug.NumUnit = OrderArr[16];            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/// 美康药典提示
function MKPrescYDTS(orditm){
	//alert("orditm:"+orditm)
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",orditm)
	//alert("ordInfoStr:"+ordInfoStr)
	var ordInfo = ordInfoStr.split("^")
	var prescNo = ordInfo[10]
	var incicode = ordInfo[8]
	var incidesc = ordInfo[9]
	var cyFlag =  ordInfo[11]		//草药标志
	
	MCInit1(prescNo);
	HisQueryData(incicode,incidesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}
	else {
		MDC_DoRefDrug(11)
	}
	
}

function HisQueryData(incicode,incidesc) {   
    var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = incicode; //查询药品的编码
    drug.CodeName =incidesc;  //查询药品的名称           
    MC_global_queryDrug = drug;   //赋值给全局变量
}


//********************** 调用美康合理用药 end   **************************/ 

//格式化列
function druguseFormatter(cellvalue, options, rowdata){
	//alert("cellvalue:"+cellvalue)
	if (cellvalue==undefined){
		cellvalue="";
	}
	if (cellvalue!=""){
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			var cellvalue = (cellvalue == 1) ? 0 : 1;
		}
	}
	var imageid="";
	if (cellvalue=="0"){
		imageid="warning0.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="warning2.gif"
	}
	else if (cellvalue=="3"){
		imageid="warning3.gif"
	}
	else if (cellvalue=="4"){
		imageid="warning4.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	return '<img src="../scripts/pharmacy/images/'+imageid+'" ></img>'
}

// ***********************界面调用方法 End ************************
