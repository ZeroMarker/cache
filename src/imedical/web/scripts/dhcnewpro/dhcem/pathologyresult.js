
var RptParm;
$(document).ready(function() {
	//初始化时间框
	initDate();
	
	//初始化BootStrap Table
	initTable();
	
	bindMethod();
	
	//table列自适应 2017-02-09
	var rtime = new Date();
    var timeout = false;
    var delta = 66;
    $(window).resize(function(){
        rtime = new Date();
        if(timeout == false){
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });
    function resizeend(){
        if(new Date() - rtime < delta){
            setTimeout(resizeend, delta);
        }else{
            timeout = false;
            $('#pathologyTable').dhccTableM("resetWidth");
        }
    }//hxy 2017-02-09
	
});	

function bindMethod(){
	$("#searchBtn").bind("click",search);
}

function initDate(){
	$('#EndDate').dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
   
    $('#StartDate').dhccDate();
    //$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	
	
}
	
function initTable(){
	var columns=[{
            field: 'Tpathid',
            title: '病理号'
        }, {
            field: 'TItemName',
            title: '医嘱名称'
        }, {
            field: 'TItemDate',
            title: '医嘱日期'
        }, {
            field: 'TItemStatus',
            align: 'center',
            title: '检查状态'
        }, {
            field: 'TReadFlag',
            align: 'center',
            title: '阅读状态'
        }, {
            field: 'TChangeStatus',
            align: 'center',
            title: '修改状态'
        }, {
            field: 'TOpenRpt',
            align: 'center',
            title: '打开报告',
            formatter:TOpenRpt
        }, {
            field: 'TLocName',
            align: 'center',
            title: '检查科室'
        }, {
            field: 'TRegNo',
            title: '登记号'
        }, {
            field: 'TOEOrderDr',
            align: 'center',
            title: '医嘱号'
        }, {
            field: 'TRptClsDesc',
            align: 'center',
            title: '报告类型'
        }, {
            field: 'TRptRowid',
            title: '报告ID',
			align: 'center'
        }]
        
	$('#pathologyTable').dhccTable({
	    height:window.parent.tabHeight-11,
	    //sidePagination:'side',
	    pageSize:15,
	    pageList:[15,30],
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMPatThisOrd&MethodName=QueryStudyByPaadmDR',//&EpisodeID='+11+'&StDate='+""+'&EndDate='+"",
        //data:[{"TRegNo":"0000000028","Tpathid":"B4570027","TItemName":"术中冰冻申请","TItemDate":"2016-04-26","TItemStatus":"确认报告","TOEOrderDr":"11||53","TLocName":"外一科","TreplocDr":"","TRptCls":"0","TRptClsDesc":"病理冰冻切片报告","TOpenRpt":"Report","TOpenAllRpt":"AllReport","TIsOpenFrostRpt":"0","TIfRead":"","TReadFlag":"6","TChangeStatus":"","TRptRowid":"已阅读","IsdelayReport":"","TReadFlag2":""},{"TRegNo":"0000000028","Tpathid":"B4570027","TItemName":"术中冰冻申请","TItemDate":"2016-04-26","TItemStatus":"确认报告","TOEOrderDr":"11||53","TLocName":"外一科","TreplocDr":"","TRptCls":"1","TRptClsDesc":"病理标本检查报告","TOpenRpt":"Report","TOpenAllRpt":"AllReport","TIsOpenFrostRpt":"0","TIfRead":"","TReadFlag":"7","TChangeStatus":"","TRptRowid":"已阅读","IsdelayReport":"","TReadFlag2":""}],
        columns: columns,
        queryParam:{
	        EpisodeID:EpisodeID,
	        StDate:"",
	        EndDate:""
	        }
    })
	}	

	
	
//查找方法	
function search(){
	var strdate=$('#StartDate').val();
	var enddate=$('#EndDate').val();
	reloadTable();
}
	
function reloadTable(){


	$('#pathologyTable').dhccQuery({
		query:{
			EpisodeID:EpisodeID,
	        StDate:"",
	        EndDate:""
		}
		})
	}
	
/*=======================Field Formatter==============================*/	
	function TOpenRpt(value, rowData, rowIndex){
		if(value=="Report"){
			return "<a onclick=\'openReport("+rowIndex+")\' href='#'><span style='color:blue;'>Report</span></a>"
			}	
		return ""
		}

	//closeImg	
/*=======================Field Formatter==============================*/

function openReport(index){
	var curRowData = $('#pathologyTable').dhccTableM('getData')[index] ; //获取当前点击行数据
   	GetRptParm(curRowData);
   	var TOEOrderDr=curRowData.TOEOrderDr;
   	var vstatus=MyRunClassMethod("web.DHCPisApplicationSheet","AddViewLog",{'UserId':UserID,'Episode':EpisodeID,'PatientID':$('#PatientID').val(),'OrderID':TOEOrderDr})
    window.open(RptParm);  
	return false;
}
	

function GetRptParm(rowData)
{
	RptParm = "";
	var TOEOrderDr=rowData.TOEOrderDr;
	var TRptCls=rowData.TRptRowid;
	var RegNo = rowData.RegNo;

	RptParm ='http://172.19.19.58/PISWeb/Default.aspx?OID='+ TOEOrderDr+'&RPTID='+TRptCls+'&DOCCODE='+UserCode;
	
	
}


///这个方法是直接运行后将结果返回
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}
