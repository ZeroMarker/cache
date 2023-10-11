/**
 * @author wujiang
 */
var typeObj={
  Fever:["Nur.Interface.OutSide.PortalUC.Ward",'QueryFeverDetail'],
  OpeToday:["Nur.Interface.OutSide.PortalUC.Ward",'QueryOperationDetail'],
  respirator:["Nur.Interface.OutSide.PortalUC.Ward",'QueryRespiratorDetail'],
  transfusion:["Nur.Interface.OutSide.PortalUC.Ward",'QueryTransfusionDetail'],
  catheter:["Nur.Interface.OutSide.PortalUC.Ward",'QueryCatheterDetail'],
  GastricTube:["Nur.Interface.OutSide.PortalUC.Ward",'QueryGastroenteroscopeDetail'],
  CVC:["Nur.Interface.OutSide.PortalUC.Ward",'QueryCVCDetail'],
  PICC:["Nur.Interface.OutSide.PortalUC.Ward",'QueryPICCDetail'],
  NewAdmission:["Nur.Interface.OutSide.PortalUC.Ward",'QueryNewIn'],
  LeaveHosp:["Nur.Interface.OutSide.PortalUC.Ward",'QueryPatOut'],
  transIn:["Nur.Interface.OutSide.PortalUC.Ward",'QueryChangeInto'],
  transOut:["Nur.Interface.OutSide.PortalUC.Ward",'QueryChangeOut'],
  highRiskReport:["Nur.Interface.OutSide.PortalUC.Ward",'GfxsbTwoPage'],
  suspectedUnderreport:["Nur.Interface.OutSide.PortalUC.Ward",'GetYslbTwoPage'],
  carelevel:["Nur.Interface.OutSide.PortalUC.Patient",'getWardCareLevelDetail'],
  patCondition:["Nur.Interface.OutSide.PortalUC.Patient",'getWardPatStatusDetail'],
  manpower:["web.INMPersonCountComm","FindPersonnelList"],
}

var saveFlag=true,page=1, pageSize=20,tableObj,columns;
// https://114.251.235.22:1443/imedical/web/csp/nur.hisui.hosstatisticaltable.csp?type=Fever^OpeToday^respirator^transfusion^catheter^GastricTube^CVC^PICC^NewAdmission^LeaveHosp&width=145px&height=80px&marginRight=15px&imgWidth=40px&imgMarginLeft=20px&fontSize=20px^14px&lineHeight=18px&MWToken=E520D5118FC9B56FA13AF0D348852DF8
// Fever^OpeToday^respirator^transfusion^catheter^GastricTube^CVC^PICC^NewAdmission^LeaveHosp&width=187px&height=82px&marginRight=20px&marginBottom=20px&imgWidth=54px&imgMarginLeft=26.3px&fontSize=26px^16px&lineHeight=23px&wrap=4

$(function() {
  console.log(window.location);
  if (typeObj[type]) {
    if (!columns&&('manpower'!=type)) {
      var data=$cm({
        ClassName: "Nur.Interface.OutSide.PortalUC.Ward",
        MethodName: "GetQueryRowspec",
        dataType: "text",
        className: typeObj[type][0],
        queryName: typeObj[type][1],
      }, false);
      console.log(data);
      data=data.split(",");
      columns=[];
      data.map(function (d) {
        d=d.split(":%String:");
        if (('hidden'!=d[1])&&d[1]) {
          columns.push({
            field:d[0],
            title:d[1],
            // width:120
          })
        }
      })
    }
    getTableData();
  }
});
// 初始化
function getTableData() {
  // 获取信息
	saveFlag=false;
  var paraObj={
    ClassName: typeObj[type][0],
    QueryName: typeObj[type][1],
    page: page,
    rows: pageSize,
    wardId: session['LOGON.WARDID'],
    // wardId: 1,
    // AdmDR: patNode.episodeID,
		// startDate:startDate,
		// endDate:endDate,
		// type:"R"
  }
  var search=window.location.search.slice(1);
  search=decodeURIComponent(search).split('&')
  search.map(function (s) {
    s=s.split('=')
    if (['type','MWToken'].indexOf(s[0])<0) {
      // paraObj[s[0]]=s[1];
      paraObj[s[0]]=s.slice(1).join('=');
    }
  })
  if ('manpower'==type) {
    delete paraObj.wardId;
    paraObj.type=paraObj.kind;
    delete paraObj.kind;
    columns=[]
    if ('职称'==paraObj.type) {
      columns=[
        {field:'PerID',title:"工号"},
        {field:'PerName',title:"姓名"},
        {field:'kind',title:"职称"},
        {field:'PerHireStDate',title:"聘用开始日期"},
        {field:'PerHireEndDate',title:"聘用截止日期"},
        {field:'WardDesc',title:"所属病区"},
      ];
    } else if ('学历'==paraObj.type) {
      columns=[
        {field:'PerID',title:"工号"},
        {field:'PerName',title:"姓名"},
        {field:'PerSchool',title:"学校"},
        {field:'kind',title:"学历"},
        {field:'PerDegree',title:"学位"},
        {field:'PerDegreeDate',title:"学位日期"},
        {field:'WardDesc',title:"所属病区"},
      ];
    } else if ('年资'==paraObj.type) {
      columns=[
        {field:'PerID',title:"工号"},
        {field:'PerName',title:"姓名"},
        {field:'PerYear',title:"年资"},
        {field:'WardDesc',title:"所属病区"},
      ];
    } else {
      columns=[
        {field:'PerID',title:"工号"},
        {field:'PerName',title:"姓名"},
        {field:'kind',title:"级别"},
        {field:'PerLevelDate',title:"晋升日期"},
        {field:'WardDesc',title:"所属病区"},
      ];
    }
  }
  $cm(paraObj, function (data) {
    console.log(data);
    if (!tableObj) {
      tableObj=$HUI.datagrid("#hostable",{
        autoSizeColumn:true,
        // checkbox:true,
        columns:[columns],
        // idField:'id',
        // treeField:'oeCatDesc',
        // headerCls:'panel-header-gray',
        pagination:true,
        pageList:[10,20,50,100,200],
        pageSize: 20,
        singleSelect:true,
        onClickRow:function(id,row){
          // var obj = {
          //   type: 'postFromProd',
          //   messageList: [
          //     {key: 'EpisodeID', value: row.episodeID}
          //   ]
          // }
          // window.parent.parent.postMessage(obj, "*");
          // debugger;
          // var frm = dhcsys_getmenuform();
          // console.log(frm);
          // if (frm) {
          //   frm.EpisodeID.value=row.episodeID;
          // }
          // var frm = opener.dhcsys_getmenuform();
          // console.log(frm);
          // if (frm) {
          //   frm.EpisodeID.value=row.episodeID;
          // }
          // var frm = window.parent.dhcsys_getmenuform();
          // console.log(frm);
          // if (frm) {
          //   frm.EpisodeID.value=row.episodeID;
          // }
          // console.log(window.parent.websys_SetEpisodeDetails);
          // console.log(websys_SetEpisodeDetails);
          // console.log(window.parent.parent.websys_SetEpisodeDetails);
        },
      })
    }
    if ('manpower'==type) {
      var rowData=[];
      data.rows.map(function (r) {
        var colData=r.aa.split('^')
        var item={kind:paraObj.detail}
        colData.map(function (c) {
          var cols=c.split('|');
          item[cols[0]]=cols[1];
        });
        rowData.push(item);
      })
      data.rows=rowData;
    }
		tableObj.loadData({
			total:data.total,
			rows:data.rows
		});
		$('#hostable').datagrid("getPager").pagination({
	    onSelectPage:function(p,size){
				page=p;
				pageSize=size;
				if (saveFlag) {
					getTableData();
				} else {
					saveFlag=true;
				}
	    },
	    onRefresh:function(p,size){
				page=p;
				pageSize=size;
				getTableData();
	    },
	    onChangePageSize:function(size){
				page=1;
				pageSize=size;
				getTableData();
	    }
		}).pagination('select', page);
    updateDomSize();
  })
}
function updateDomSize() {
  var n=0
  var timer=setInterval(function() {
    $('#hostable').datagrid('resize',{
      height:window.innerHeight
    })
    n++;
    if (n>5) clearInterval(timer);
  }, 50);
}
window.addEventListener("resize",updateDomSize);
