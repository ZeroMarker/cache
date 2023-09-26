//$(window).ready(function(){
websys_$(function($) {
	$("#PatientView").bind("click",function(){
	});
	InitPatientViewList()
	InitTab()
	///登记号回车事件
	$("#PatientNo").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        FindPatientView()
        return false;
      }
    });
	///病人姓名的回车事件
	$("#PatientName").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        FindPatientView()
        return false;
      }
    });
	///病案号回车
	$("#MedicalNo").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        FindPatientView()
        return false;
      }
    });
	///床号回车
	$("#BedNo").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        FindPatientView()
        return false;
      }
    });
	///出院天数
	$("#DisDay").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        FindPatientView()
        return false;
      }
    });
	$("#Find").click(function(){
		FindPatientView()
	})
})
function PatientViewClick(){
	$("#PatientViewWin").window("open")
	
}
function InitTab(){
	
	$("#PatientViewTab").tabs("add",{
		title:"本人病人"
	})
	$("#PatientViewTab").tabs("add",{
		title:"本科室病人"
	})
	$("#PatientViewTab").tabs("add",{
		title:"本单元病人"
	})
	$("#PatientViewTab").tabs("add",{
		title:"在院转科病人"
	})
	$("#PatientViewTab").tabs("add",{
		title:"医生授权病人"
	})
	$("#PatientViewTab").tabs("select","本人病人")
	$("#PatientViewTab").tabs({
		onSelect:function(){
			var tab=$("#PatientViewTab").tabs("getSelected")
			$("#PatientNo").val("")
			$("#PatientName").val("")
			$("#MedicalNo").val("")
			$("#BedNo").val("")
			$("#DisDay").val("")
			PatientViewGridLoad()
		}
	})
	//$("#PatientViewTab").tabs('options').headerWidth=90
}
 function InitPatientViewList(){
	$("#PatientViewGrid").datagrid({
		width:'auto',
		border:true,
		striped:true,
		singleSelect:true,
		autoRowHeight:true,
		fitColumns : false,
		url:'',
		loadMsg:'正在加载',
		rownumbers:true,
		pagination:true,
		pageSize: 20,//每页显示的记录条数，默认为10   
		pageList: [10,20,30],
		columns:PatientViewCol,
		onSelect:function(rowid,RowData){
		},
		onDblClickRow:function(rowIndex,rowData){
			var PatientId=rowData.PatientID
			var EpisodeID=rowData.EpisodeID
			var mradm=rowData.mradm
			var PAPMISex=rowData.PAPMISex
			PatientViewGridClick(PatientId,EpisodeID,mradm,PAPMISex,true)
			$("#PatientViewWin").window("close")
		}
	});
	var pager = $('#PatientViewGrid').datagrid().datagrid('getPager');     
	pager.pagination({ 
		beforePageText:"第",
		afterPageText:'共{pages}',
	  displayMsg:'显示{from}到{to},共{total}记录'  
	});
	defaultHaveScroll("PatientViewGrid")
	setTimeout("PatientViewGridLoad()",10)
 }
 
 function PatientViewGridLoad()
 {
	//alert(LocRowid+","+DocRowid+","+StartDate+","+userid+","+","+groupid+","+ExaRowid)
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocMain';
	queryParams.QueryName ='FindCurrentAdmProxy';
	var tab=$("#PatientViewTab").tabs("getSelected")
	queryParams.Arg1 =$('#PatientViewTab').tabs('getTabIndex',tab);
	queryParams.Arg2 =$("#PatientNo").val();
	queryParams.Arg3 =$("#PatientName").val();
	queryParams.Arg4 =$("#MedicalNo").val();
	queryParams.Arg5 =PAADMType;
	queryParams.Arg6 ="";  //CardNo
	queryParams.Arg7 =$("#BedNo").val();;	// 资源ID
	queryParams.Arg8 ="";  //Ward
	queryParams.Arg9 ="";  //DisDay
	queryParams.Arg10 =""; //IllType
	queryParams.Arg11 =""; //Doc
	queryParams.ArgCnt = 11;
	var opts = $("#PatientViewGrid").datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#PatientViewGrid").datagrid('load', queryParams); 
 }
 function FindPatientView()
 {
	var patientNo = $("#PatientNo").val()
	var ruleNo="", len = regLength,patLen;
	for(var i=0;i<len;i++){ruleNo += '0' ;}
	if(patientNo!=""){
		patLen = patientNo.length;
		if(len-patLen>=0){
			patientNo = ruleNo.slice(0,len-patLen)+patientNo;
		}else{
			patientNo = patientNo.slice(patLen-len);
		}
		$("#PatientNo").val(patientNo);
	}
	
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocMain';
	queryParams.QueryName ='FindCurrentAdmProxy';
	var tab=$("#PatientViewTab").tabs("getSelected")
	queryParams.Arg1 =$('#PatientViewTab').tabs('getTabIndex',tab);
	queryParams.Arg2 =$("#PatientNo").val();
	queryParams.Arg3 =$("#PatientName").val();
	queryParams.Arg4 =$("#MedicalNo").val();
	queryParams.Arg5 =PAADMType;
	queryParams.Arg6 ="";  //CardNo
	queryParams.Arg7 =$("#BedNo").val();;	// 资源ID
	queryParams.Arg8 ="";  //Ward
	queryParams.Arg9 =$("#DisDay").val()
	queryParams.Arg10 =""; //IllType
	var MainDocDesc=Ext.getCmp("patientMainDocTF").getRawValue()
	var MainDocId=Ext.getCmp("patientMainDocTF").getValue()
	if (MainDocDesc==""){var MainDocId="";}
	queryParams.Arg11 =MainDocId;
	
	var WardProGroupDesc=Ext.getCmp("WardProGroupList").getRawValue()
	var WardProGroupId=Ext.getCmp("WardProGroupList").getValue()
	if (WardProGroupDesc==""){var WardProGroupId="";}
	queryParams.Arg12 =WardProGroupId;
	
	var HavedSeeOrdPat=document.getElementById("HavedSeeOrdPat").checked;
	if (HavedSeeOrdPat){
		HavedSeeOrdPat="on";
	}else{
		HavedSeeOrdPat="";
	}
	queryParams.P13 = HavedSeeOrdPat;
	
	
	queryParams.ArgCnt = 13;
	var opts = $("#PatientViewGrid").datagrid("options");
	opts.url = "./dhcdoc.cure.query.grid.easyui.csp"
	$("#PatientViewGrid").datagrid('load', queryParams); 
 }
 
 
 
 //easyUI默认出现滚动条  
function defaultHaveScroll(gridid){  
    var opts=$('#'+gridid).datagrid('options');  
    // alert(Ext.util.JSON.encode(opts.columns));  
    var text='{';  
    for(var i=0;i<opts.columns.length;i++){  
       var inner_len=opts.columns[i].length;  
       for(var j=0;j<inner_len;j++){  
           if((typeof opts.columns[i][j].field)=='undefined')break;  
            text+="'"+opts.columns[i][j].field+"':''";  
            if(j!=inner_len-1){  
                text+=",";  
            }  
       }  
    }  
    text+="}";  
    text=eval("("+text+")");  
    var data={"total":1,"rows":[text]};  
    $('#'+gridid).datagrid('loadData',data);  
   // $('#grid').datagrid('appendRow',text);  
   $("tr[datagrid-row-index='0']").css({"visibility":"hidden"});  
}
function PatientViewGridClick(PatientId,EpisodeID,mradm,PAPMISex,forceRefresh){
	var Sex = PAPMISex;
	var canGiveBirth = (Sex=="女")?1:0;
	if((true===forceRefresh) || (DHCDocMainView.EpisodeID != eid)){
		tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
		DHCDocMainView.PatientID = PatientId;
		DHCDocMainView.EpisodeID = EpisodeID;
		DHCDocMainView.mradm = mradm;
		setEprMenuForm(EpisodeID,PatientId,mradm,canGiveBirth);
		refreshBar();
		var p = Ext.getCmp("DHCDocTabPanel").getActiveTab();
		isVaildUseDHCOE(p)
		if (p.allRefresh === true){						
			hrefRefresh(forceRefresh);
		}else{
			xhrRefresh(forceRefresh);
		}
	}
}
