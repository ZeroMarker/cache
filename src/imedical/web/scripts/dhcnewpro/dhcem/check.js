/// Creator: huaxiaoying
/// CreateDate: 2016-08-06
//var EpisodeID=EpisodeID;//����ID
$(document).ready(function() {
	//��ʼ��ʱ���
	initDate();
	
	//��ʼ��select2
	initSelect2();
	
	//��ʼ��BootStrap Table
	initTable();
	
	//�󶨷���
	bindMethod();
    
	//alert(LgUserCode);
	//table������Ӧ 2017-02-09
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
            $('#execTable').dhccTableM("resetWidth");
        }
    }//hxy 2017-02-09

	
   
});	


function initDate(){
	$('#EndDate').dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))	
   
    $('#StartDate').dhccDate();
    //$("#StartDate").setDate(new Date().Format("yyyy-MM-dd"))	
	
	}
	
function initSelect2(){
	//$("#diagLoc").dhccSelect({
	//	url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getAdmListByAdm&PaAdm="+EpisodeID+"&StartDate="+$('#StartDate input').val()+"&EndDate="+$('#EndDate input').val()
	//	 })
	//ShowDiagLoc();   //�������֮����Ҫ��Ajax��������ΪҪ���ó�ʼֵ
	$('#InspectSort').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=ListInspectSort" 
		})
	
	$('#CheckName').dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getExamineName" 
		})
	$("#diagLoc").dhccSelect({
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheOutNew&MethodName=getAdmListByAdm&PaAdm="+EpisodeID+"&StartDate="+$('#StartDate input').val()+"&EndDate="+$('#EndDate input').val()
		 })	
	
		
		
}
function ShowDiagLoc(){
	
}

	
function initTable(){
	var columns=[{
            checkbox: true
        },{
            field: 'RegNo',
            title: '�ǼǺ�'
        }, {
            field: 'StudyNo',
            title: '����'
        }, {
            field: 'ItemName',
            title: 'ҽ������'
        }, {
            field: 'ItemDate',
            title: 'ҽ������'
        }, {
            field: 'ItemStatus',
            align: 'center',
            title: '�Ƿ񷢲�'
        }, {
            field: 'IsReaded',
            align: 'center',
            title: '�Ƿ��Ѷ�'
        }, {
            field: 'IsModify',
            align: 'center',
            title: '�Ƿ��޸�'
        }, {
            field: 'OpenRpt',
            align: 'center',
            title: '�򿪱���',
            formatter:openRpt
            
        }, {
            field: 'IsIll',
            align: 'center',
            title: '�Ƿ�����'
        }, {
            field: 'LocName',
            align: 'center',
            title: '������'
        }, {
            field: 'IshasImg',
            align: 'center',
            title: '�Ƿ���ͼ��'
        }, {
            field: 'seeImg',
            align: 'center',
            title: '���ͼ��',
            formatter:seeImg
        },  {
            field: 'MediumName',
            align: 'center',
            title: '����'
        }, {
            field: 'Memo',
            align: 'center',
            title: '��ע'
        }, {
            field: 'OEOrderDr',
            align: 'center',
            title: 'OEOderDr'
        }, {
            field: 'replocdr',
            title: '����Dr',
			align: 'center'
        }]
        
	$('#execTable').dhccTable({
	    height:window.parent.tabHeight-71,
	    //sidePagination:'side',
	    pageSize:15,
	    pageList:[50,100],
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMCheck&MethodName=ListCheckResult',
        columns: columns,
        queryParam:{
	        paadmdr:EpisodeID,
	        LocDr:"",
	        ALLFlag:"Y",
	        arci:""
	        }
    })
	}	

function bindMethod(){
	$("#searchBtn").bind("click",search);
	//$("#diagLoc").on("select2:close", reloadTable) 
	 $('#diagLoc').on('select2:select', function (evt) {
		search();
		});
	}
	
	
//���ҷ���	
function search(){
	reloadTable();
	}
 
 //reload	
function reloadTable(){
	var PaAdm = $("#diagLoc").val()==null?"":$("#diagLoc").val();

	if(PaAdm!=""){
		AllFlag="N"
	}else{
		AllFlag="Y"
		PaAdm=EpisodeID
	}
	
	$('#execTable').dhccQuery({
		query:{
			paadmdr:PaAdm,
			LocDr:"",
	        ALLFlag:AllFlag,
	        arci:$("#CheckName").val(),
	        StdDate:$('#StartDate input').val(),
    		enddate:$('#EndDate input').val(),
    		ItmArcCatDr:$('#InspectSort').val()
		}
		})
	}
	
/*=======================Field Formatter==============================*/	
	function openRpt(value, rowData, rowIndex){
		if(value=="����"){
			return "<a onclick=\'openReport("+rowIndex+")\' href='#'><span style='color:blue;'>����</span></a>"
			}	
		return ""
		}
		
	function seeImg(value, rowData, rowIndex){
			if(rowData.IshasImg!="N"){
				return "<a onclick=\'seeImage("+rowIndex+")\' href='#'><span style='color:blue;'>ͼ��</span></a>"
				}
			if(rowData.IshasImg=="N"){
				return ""
				}
		}	
		

		
		
	//closeImg	
/*=======================Field Formatter==============================*/

function openReport(index){
	
	var curRowData = $('#execTable').dhccTableM('getData')[index] ; //��ȡ��ǰ���������
   	GetRptParm(curRowData);
    if((RptParm!="")&&(RptParm!=" "))
    {
	        var ret=SaveRecord(curRowData,"R");
	        if (ret!="0")
	        {
		        alert("������������¼error!");
		        return false;
		    }
		    var Item=RptParm.split(":")
		    if (Item[0]=="http")
		    {
		       window.open(RptParm, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
		    }
		    else 
		    {
				
				 	var curRptObject = new ActiveXObject("wscript.shell");
					
					curRptObject.run(RptParm);
		
			    }
			    
		        return false;
		}
	
	return false;
	}
	
function seeImage(index){
	var curRowData = $('#execTable').dhccTableM('getData')[index] ; //��ȡ��ǰ���������
	var OtherParam = curRowData.ImageUrl;
	 if (OtherParam != "") {
     //�����������ġA��Դ���ⲿ��URL
        ImgParm = OtherParam;
     }
     else {
         GetImgParm(curRowData);
     }
 
       if ((ImgParm != " ") && (ImgParm != "")) {
            var ret = SaveRecord("I");
            if (ret != "0") {
                alert("�������ͼ���¼error!");
                return false;
            }
            var ImageItem = ImgParm.split(":");
            if (ImageItem[0] == "http") {
                window.open(ImgParm, "newwindow", "height=700, width=900, toolbar= no, menubar=no,  location=no, status=no,top=100,left=300");
            }
            else {
                var curRptObject = new ActiveXObject("wscript.shell");
                var ret = curRptObject.Exec(ImgParm);
            }

            return false;
        }
        else {
            var ViewObject = new ActiveXObject("CallVPXCom.CallVpx.1");
            ViewObject.LoadPatientStudyImages(PatientID, StudyNo); //PatientID
            return false;
        }

}
function GetRptParm(rowData)
{
	RptParm = "";
	var LocDr = rowData.replocdr;
	var StudyNo=rowData.StudyNo;
	var RegNo = rowData.RegNo;
	var OEOrdItem=rowData.OEOrderDr;
	

	var Info = MyRunClassMethod("web.DHCRisclinicQueryOEItemDo","GetClinicSet",{LocDr:LocDr})

	var Infolist=Info.split("^");
	
	var ReportFullFil,RhasReg,RRegParam,RhasStudyNo,RStuyParam,RDelim,RhasOParam,ROtherParam
 	ReportFullFil=Infolist[0];  //http://***.**.**/***/**/
  	RhasReg=Infolist[1];        //"N"
    RRegParam=Infolist[2];		//" "
	RhasStudyNo=Infolist[3];    //"N"
	RStuyParam=Infolist[4];     //""
	RDelim=Infolist[5];			//" "
	RhasOParam=Infolist[12];	//"Y"
	ROtherParam=Infolist[13];	//?OID=""
	
	//UserID=session['LOGON.USERID'];
	
	if (RhasReg=="Y")
	{
		RptParm = RRegParam+RegNo;
	}
	if (RDelim!="")
	{
		RptParm = RptParm + RDelim;
	}
	if (RhasStudyNo=="Y")
	{
	   
	    RptParm="&SID="+StudyNo;
	}
	
	if(RhasOParam=="Y")
	{
	   var OElist1=OEOrdItem.split("||")[0]
	   var OElist2=OEOrdItem.split("||")[1]
	   if(ROtherParam=="DHCC")
	   {
	      //RptParm="?LID="+cLocDr+"&SID="+StudyNo+"&OID="+OEOrdItem
	      RptParm="&LID="+LocDr+"&SID="+StudyNo+"&OID="+OEOrdItem+"&USERID="+UserID;
	   }
	   else if (ROtherParam!="")
	   {
		   
		    //RptParm=ROtherParam+OEOrdItem
		    RptParm=ROtherParam+OEOrdItem+"&USERID="+UserID;
	   }
	   else
	   {
		    RptParm=OEOrdItem
	   }	   
	}
	
	RptParm = ReportFullFil + RptParm;
	
	if(ReportFullFil=="RptView.DLL")
	{
		RptParm = "RptView.DLL";
	}
	if(ReportFullFil=="PISRptView.DLL")
	{
		RptParm = "PISRptView.DLL";
	}
	
}
//�鿴ͼ����õķ���
function GetImgParm(rowData) {
    ImgParm = "";
    var LocDr = rowData.replocdr;
	var StudyNo=rowData.StudyNo;
	var RegNo = rowData.RegNo;
	var OEOrdItem=rowData.OEOrderDr;
	var Info = MyRunClassMethod("web.DHCRisclinicQueryOEItemDo","GetClinicSet",{LocDr:LocDr})
    var Infolist = Info.split("^");
    var ImageFullFile, IhasReg, IRegParam, IhasStudyNo, IStudyNoParam, IDelim, IhasOtherParam;
    ImageFullFile = Infolist[6];
    IhasReg = Infolist[7];
    IRegParam = Infolist[8];
    IhasStudyNo = Infolist[9];
    IStuyParam = Infolist[10];
    IDelim = Infolist[11];
    IOtherParam = Infolist[14];
    IhasOtherParam = Infolist[15];

    if (IhasReg == "Y") {
        ImgParm = IRegParam + RegNo;
    }
    if (IDelim != "") {
        ImgParm = ImgParm + IDelim;
    }
    if (IhasStudyNo == "Y") {
        if (StudyNo == " ") {
            ImgParm = ImgParm + IStuyParam + OEOrdItem;
        }
        else {

            if (IhasOtherParam == "Y") {

                if (IOtherParam == "AGFA") {
                    ImgParm = "&SID=" + StudyNo;
                }
            }
            else {
                ImgParm = ImgParm + IStuyParam + StudyNo;
            }

        }
    }


    ImgParm = ImageFullFile + ImgParm;


    /*if(IhasOtherParam=="Y")//�����ӵ���Ӱ��
     {
     alert("1");
     ImgParm = ImageFullFile+OtherParam;
     }*/

}


function SaveRecord(rowData,Code)
{
	//var ClinicRecordSetFunction=document.getElementById("ClinicRecordSet").value;
	var LocDr = rowData.replocdr;
	var StudyNo=rowData.StudyNo;
	var RegNo = rowData.RegNo;
	var OEOrdItem=rowData.OEOrderDr;
	SaveInfo=LocDr+"^"+LoginLocID+"^"+RegNo+"^"+StudyNo+"^"+UserID+"^"+OEOrdItem;
	
	var ret=MyRunClassMethod("web.DHCRisclinicQueryOEItemDo","ClinicRecordSet",{AllInfo:SaveInfo,Code:Code});
	return ret
}


///���������ֱ�����к󽫽������
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
