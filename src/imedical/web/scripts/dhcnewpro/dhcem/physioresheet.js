/// Creator: congyue
/// CreateDate: 2016-08-11
///  Descript: ҽ����

var TagCode="",CategoryRowId="",Dep=1;
var BPRNSTR="";
var hospitalDesc;
var btOffset; //��ʼ����
var btLimit;  //һҳ������
var btTotal; //������
$(document).ready(function() {
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
            $('#phypreshetb').dhccTableM("resetWidth");
        }
    }//hxy 2016-12-30

	//alert(EpisodeID);
    //��ʼ����
    $('#StDate').dhccDate();
	//$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 ���ڸ�ʽ������
				function(data){
					if(data==3){
						$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))
				    }else if(data==4){
					    $("#StDate").setDate(new Date().Format("dd/MM/yyyy"));
					}else{
						return;
					}
				});
    //��������
    $('#EndDate').dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 ���ڸ�ʽ������
				function(data){
					if(data==3){
						$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
				    }else if(data==4){
					    $("#EndDate").setDate(new Date().Format("dd/MM/yyyy"));
					}else{
						return;
					}
				});	
	//��ѡ�����
	InitUIStatus();
	//��ѡ��ť�¼� xiugai lvpeng 2016-12-29
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			if(this.id=="SelDate"){
				if($(this).is(':checked')==true){
					$('#ifshow').show();
				}else{
					$('#ifshow').hide();
				}
			}
		});
	});	
	
	//xiugai lvpeng 2016-12-29
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			 if($(this).attr('checked')=="checked"){
                    $(this).attr("checked",false);
                }else{
                    $(this).attr("checked",true);
                }
			})
	})

	$("#queryBtn").on('click',function(){	//��ѯ��ť�¼�
		search();
	})
	
	//ҽ�����б� 
    $('#phypreshetb').dhccTable({
	    formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "�� "+pageFrom+" ���� "+pageTo+" ����¼���� "+totalRows+" ����¼"+"<div id='pageTo' style='display:none'>"+totalRows+"</div>"
		},//huaxiaoying 2017-01-17
	    height:window.parent.tabHeight-95,
	    pageSize:200,//ÿҳ��ʾ����
        idField: 'id',
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        columns: [{
			field: 'OerdDate',
			title: '��ʼ����',
			align: 'center'
		}, {
			field: 'OerdTime',
			title: '��ʼʱ��',
			align: 'center'
		}, {
			field: 'Doctor',
			title: 'ҽ��',
			align: 'center'
		},  {
			field: 'ARCIMDesc',
			title: 'ҽ������',
			formatter:orderName,
			align: 'center'
		}, {
			field: 'seqNo',
			title: 'ҽ�����',
			align: 'center'
		},{
			field: 'DateEx',
			title: 'ִ������',
			align: 'center'
		}, {
			field: 'TimeEx',
			title: 'ִ��ʱ��',
			align: 'center'
		}, {
            field: 'ExDC',
            align: 'center',
            title: 'ִ����'
        },{
            field: 'DisposTime',
            align: 'center',
            title: '����ʱ��'
        }, {
            field: 'DisposNur',
            align: 'center',
            title: '������'
        },  {
            field: 'ORW',
            align: 'center',
            title: 'ORW'
        }, {
            field: 'ProcessNo',
            align: 'center',
            title: '���̺�'
			
        }],
        queryParam:{
			Adm:EpisodeID,    
    		stop:$("#AllOrd:checked").val()=="1"?1:0,
    		ssuser:"",
    		NurOrd:$("#NurOrd:checked").val()=="1"?1:0,
    		DocOrd:$("#DocOrd:checked").val()=="1"?1:0,
    		OrdType:""
		},
		onLoadSuccess:function(data){
			btLimit=data.limit;
			btOffset=data.offset;
			btTotal=data.total;
			
		}
    });
    
});	

/// 2016/8/24 11:31:29
/// Title��������ʽ�޸�
function orderName(value,rowData,rowIndex){
	return "<b class='ordertitle'>"+value+"</b>" ;
	}

function InitUIStatus()
{
	var tmpid="";
	$("input[type=checkbox]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][name="+this.name+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
function StuModel(){
	
   $('#StPage').val("");
   $('#StRow').val("");
   $('#EdPage').val("");
   $('#EdRow').val("");
}
function StModel(){
	
   $('#EdRow').val("");
}

/// add lvpeng 16-12-29
function search(){
	if($('#OrdLong').attr('checked')=="checked"){
		findLong();	//����
	}if($('#OrdTemp').attr('checked')=="checked"){
		Temp_click(); //����
	}if($('#SelDate').is(':checked')){
		//��ʼ����
    	StDate=$('#StDate input').val();
    	//��������
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("��ѡ��ʼ�������������");
			return;   //ssuser
		}
		$('#phypreshetb').dhccQuery({
		query:{
			//Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"����ҽ��"
			Adm:EpisodeID, 
			StartDate:StDate,
			EndDate:EndDate,  
    		stop:$("#AllOrd:checked").val()=="1"?1:0,
    		ssuser:"",
    		NurOrd:$("#NurOrd:checked").val()=="1"?1:0,
    		DocOrd:$("#DocOrd:checked").val()=="1"?1:0,
    		OrdType:""
		}
		})
	}else{
		$('#phypreshetb').dhccQuery({
		query:{
			//Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"����ҽ��"
			Adm:EpisodeID,
			StartDate:"",
			EndDate:"",
    		stop:$("#AllOrd:checked").val()=="1"?1:0,
    		ssuser:"",
    		NurOrd:$("#NurOrd:checked").val()=="1"?1:0,
    		DocOrd:$("#DocOrd:checked").val()=="1"?1:0,
    		OrdType:""	
			}
		})
	}
}
///����ҽ��
function findLong()
{
    var RegNo=RegNo;  
    var AdmCom=EpisodeID;  
    var Adm=EpisodeID;
    var ssuser="";
    var StDate="",EndDate="";
    //�����ڲ�ѯ
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;
		}
	})
	if (SelDate==1){
		//��ʼ����
    	StDate=$('#StDate input').val();
    	//��������
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("��ѡ��ʼ�������������");
			return;   //ssuser
		}
	}
    //ȫ��
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //����
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //ҽ��
    var DocOrd =0;
    $("input[type=checkbox][name=DocOrd]").each(function(){
		if($(this).is(':checked')){
			DocOrd =this.value;
		}
	})
  	$('#phypreshetb').dhccQuery({
		query:{
			Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"����ҽ��"
			}
	}) 
}
///��ʱҽ��
function Temp_click()
{
    var RegNo=RegNo;  
    var AdmCom=EpisodeID;  
    var Adm=EpisodeID;
    var ssuser="";
    var StDate="",EndDate="";
    if ((Adm=="")) {alert(t['alert:EpisodeIDNull']);return false;};
    //�����ڲ�ѯ
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;
		}
	})
	if (SelDate==1){
		//��ʼ����
    	StDate=$('#StDate').getDate();
    	//��������
    	EndDate=$('#EndDate').getDate();
		if ((StDate=="")||(EndDate==""))
		{
			alert("��ѡ��ʼ�������������");
			return;   //ssuser
		}
	}
    //ȫ��
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //����
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //ҽ��
    var DocOrd =0;
    $("input[type=checkbox][name=DocOrd]").each(function(){
		if($(this).is(':checked')){
			DocOrd =this.value;
		}
	})
  	$('#phypreshetb').dhccQuery({
		query:{
			Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"��ʱҽ��"
			}
	}) 
}

///��ӡ��ǰ
function PrintCurrClick()
{
	XPrintClick(2);
	return;

}
///��ӡ
function PrintClick()
{   
	XPrintClick(1);
	return;
/* 	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        var  path = GetFilePath();
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=$('#phypreshetb').dhccTableM('getData')[0].ProcessNo;
		var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //��ȡ��������
	    var PRow=28;//lines per pages
	    var pnum=0; //pages
	    var frw=2;
		for (i=1;i<num+1;i++) //���д�ӡ
	     {
		   var res=serverCall( "web.DHCEMPhysiOreSheet", "GetItem",{ 'i':i,'Adm':EpisodeID,'strj':strj});
		   var data=res.split("^");
           var lnum=1+PRow*pnum;
		   if (lnum==1) gridset(xlsSheet,1,1,9,1,11);
		   xlsSheet.cells(frw,1)=data[0];
		   xlsSheet.cells(frw,2)=data[1];
		   xlsSheet.cells(frw,3)=data[2];
		   xlsSheet.cells(frw,4)=data[3];
		   xlsSheet.cells(frw,5)=data[5];
		   xlsSheet.cells(frw,6)=data[6];
		   xlsSheet.cells(frw,7)="";
		   
		   var pres=frw%PRow;
		   if (pres==0)
		   {
			   pnum=pnum+1;
		       frw=frw+1;
		       gridset(xlsSheet,frw,1,7,frw,11);
		       frw=frw+2
		   }
		   else
		   {
			   frw=frw+1
		   }
		    
		 }
        hospitalDesc=serverCall( "web.DHCCLCom", "GetHospital");
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+'�� ʱ ҽ �� ��';
	    var info=serverCall( "web.DHCCLCom", "PatInfo",{'curId':RegNo+"^"+EpisodeID});
	    
	    var infoarr=info.split("^");
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+'����'+":"+infoarr[4]+"    "+'�Ʊ�:'+infoarr[1]+"     "+'����'+infoarr[2]+"      "+'�ǼǺ�: '+infoarr[0];LeftFooter = "";CenterFooter = '&10�� &P ҳ';RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
		gridlist(xlsSheet,1,i+sherow,1,7);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview ;
 */
}
function gridset(xlsSheet,r,c1,c2,frw,fontnum)
{
     fontcell(xlsSheet,r,c1,c2,fontnum);
	 xlcenter(xlsSheet,r,c1,c2);
	 xlsSheet.cells(frw,1)='����';
	 xlsSheet.cells(frw,2)='ʱ��';
	 xlsSheet.cells(frw,3)='ҽ������';
	 xlsSheet.cells(frw,4)='ҽ��ǩ��';
	 xlsSheet.cells(frw,5)='ִ��ʱ��';
	 xlsSheet.cells(frw,6)='��ʿǩ��';
	 xlsSheet.cells(frw,7)='��ע';


}
function GetFilePath()
{   
	//1����ȡXLS����·��
	var path=serverCall( "web.DHCLCNUREXCUTE", "GetPath");
    return path;
}
//����ҽ��
function PrintSet()
{
	var StPage=$('#StPage').val();
	var StRow=$('#StRow').val();
	var EdPage=$('#EdPage').val();
	var EdRow=$('#EdRow').val();
	var PRow=28;//ÿҳ����
	var page=Math.ceil(btTotal/PRow);
	if((StPage=="")||(StRow=="")||(EdPage=="")||(EdRow=="")){
		alert("�������Ϊ��,����������!");
		return;
	}
	
	if((isNaN(StPage)==true)||(isNaN(StRow)==true)||(isNaN(EdPage)==true)||(isNaN(EdRow)==true)){
		alert("����������,����������!");
		return;
	}

	if((StPage>page)||(EdPage>page)||(StPage>EdPage)){
	   alert("ҳ����������,����������!");
	   return;
	}
	if((StRow>PRow)||(EdRow>PRow)){
	   alert("������������,����������!");
	   return;
	} 
	if(StRow>$('#pageTo').html()){  //huaxiaoying 2017-01-17
	   dhccBox.alert("��ʼ�в��ܴ���������"+$('#pageTo').html()+" !","sheet-two");
	   return;
	} 
	if(EdRow>$('#pageTo').html()){  //huaxiaoying 2017-01-17
	   dhccBox.alert("�����в��ܴ���������"+$('#pageTo').html()+" !","sheet-one");
	   //alert("�����в��ܴ���������"+$('#pageTo').html()+" !");
	   return;
	} 
   var str=StPage+"|"+StRow+"|"+EdPage+"|"+EdRow;

   BPRNSTR=str;
   XPrintClick(0);

}

//��ӡԤ��
function SetStpage()
{
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        var  path = GetFilePath();
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=$('#phypreshetb').dhccTableM('getData')[0].ProcessNo;
		var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //��ȡ��������
	    var PRow=28;//lines per pages
	    var pnum=0; //pages
	    var frw=2;
		for (i=1;i<num+1;i++) //���д�ӡ
	     {
		   var res=serverCall( "web.DHCEMPhysiOreSheet", "GetItem",{ 'i':i,'Adm':EpisodeID,'strj':strj});
		   var data=res.split("^");
           var lnum=1+PRow*pnum;
		   if (lnum==1) gridset(xlsSheet,1,1,9,1,11);
		   xlsSheet.cells(frw,1)=data[0];
		   xlsSheet.cells(frw,2)=data[1];
		   xlsSheet.cells(frw,3)=data[2];
		   xlsSheet.cells(frw,4)=data[3];
		   xlsSheet.cells(frw,5)=data[5];
		   xlsSheet.cells(frw,6)=data[6];
		   xlsSheet.cells(frw,7)="";
		   
		   var pres=frw%PRow;
		   if (pres==0)
		   {
			   pnum=pnum+1;
		       frw=frw+1;
		       gridset(xlsSheet,frw,1,7,frw,11);
		       frw=frw+2
		   }
		   else
		   {
			   frw=frw+1
		   }
		    
		 }
        hospitalDesc=serverCall( "web.DHCCLCom", "GetHospital");
        var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+'�� ʱ ҽ �� ��';
	    var info=serverCall( "web.DHCCLCom", "PatInfo",{'curId':RegNo+"^"+EpisodeID});
	    var infoarr=info.split("^");
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+'����'+":"+infoarr[4]+"    "+'�Ʊ�:'+infoarr[1]+"     "+'����'+infoarr[2]+"      "+'�ǼǺ�: '+infoarr[0];LeftFooter = "";CenterFooter = '&10�� &P ҳ';RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
		gridlist(xlsSheet,1,i+sherow,1,7);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview ;
}
function PageBtn_Click()
{
	//ҳ��
	var PagNo=$('#PagNo').val();  //var page=document.getElementById("PagNo").value;
	//����id
	var Adm=EpisodeID;  //var adm=document.getElementById("Adm").value;
	var ssuser="";
 	var pageNum;
	if (PagNo!="")
	{
		pageNum=eval(PagNo)-1
	}else{
		return;
	}
    //ȫ��
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //����
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //ҽ��
    var DocOrd =0;
    $("input[type=checkbox][name=DocOrd]").each(function(){hosp
    
		if($(this).is(':checked')){
			DocOrd =this.value;
		}
	})
  	$('#phypreshetb').dhccQuery({
		query:{
			Adm:Adm,StartDate:"",EndDate:"",stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,TPAGCNT:pageNum,TSRT:0
			}
		
	}) 
}
function XPrintClick(PrTyp)
{     

	try{
	  var Adm=EpisodeID;
	   var DepNo=RegNo;
	   var ssuser="";
	   var ExeLongQuery=serverCall( "web.DHCEMPhysiOreSheet", "ExeTempQuery",{ 'Adm':EpisodeID,'Dep':DepNo,'ssuser':ssuser});
	   var Processj;
	   if (PrTyp==2){}else{  
	   Processj=serverCall( "web.DHCEMPhysiOreSheet", "ExeTempQuery",{ 'Adm':EpisodeID,'Dep':DepNo,'ssuser':ssuser});///ExeQuery(ExeLongQuery,Adm,DepNo,session['LOGON.USERID']);
	   }
	   var truthBeTold = window.confirm('�鿴��ӡ����û��������ӡ��ҵ����?ȷ��?����?����?ȡ��?ֹͣ?');
       if (!truthBeTold) {
	       return;
       }
	    var xlsExcel,xlsSheet,xlsBook;
	    var i,j;
        var  path = GetFilePath();
        var fileName="lsyz1.xls" ;//+ fileName;
        fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    //var Adm=document.getElementById("Adm").value;
	    xlsBook = xlsExcel.Workbooks.Add(fileName) //;Open(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;//  Worksheets(1)
	   	var strj=Processj; 
	   	if (PrTyp==2){
		   	strj=$('#phypreshetb').dhccTableM('getData')[0].ProcessNo;
	   	}
	    var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //��ȡ��������
	    //�쿴��ӡ��ҳ�������
	    var Res,TmpRes;
	    var Print;
	    var StPage=0,EdPage=0;
	    var StRow=0,EdRow=0;
	    var PageStr;
        var bdprn;
        var PRow=28;//ÿҳ����
	    var pnum=0; //ҳ��
	    var frw=1; 
	    var cols=7;
	    var PageNum="";
	    var starti=1
	    var ret=serverCall( "web.DHCEMPhysiOreSheet", "GetStartPage",{ 'typ':'lsord','adm':Adm,'Dep':Dep,'depNo':DepNo});
	    //var ret=serverCall( "web.DHCEMPhysiOreSheet", "GetStartPage",{ 'typ':'lsord','adm':Adm,'Dep':Dep,'depNo':depNo});
		if (ret=="") PageNum=1;
	    
	    var ClearStr="A1:G28";
      	bdprn=false;
	    Print=false;
	    Res=serverCall( "web.DHCEMPhysiOreSheet", "schtystrow",{'typ':'lsord','adm':EpisodeID,'Dep':Dep,'tranNo':DepNo});
	    ///s val=##Class(%CSP.Page).Encrypt($lb("web.DHCTEMPOERPRINT.schtystrow"))
	    
	    if ((BPRNSTR!="")||(PrTyp==2)){
		   bdprn= true;   
		    }
 	    if (bdprn)
 	    {  //��������
	       PageStr=BPRNSTR.split("|");
           StPage=Number(PageStr[0]);
	       StRow=Number(PageStr[1]);
		   EdPage=Number(PageStr[2]);
		   EdRow=Number(PageStr[3]);
		  if (BPRNSTR) 
	      {
		    var numb;
		    
		    //num=(EdPage-1)*btLimit+EdRow
		    //starti=(StPage-1)*btLimit+StRow
		    
		    num=(EdPage-1)*PRow+EdRow
		    starti=(StPage-1)*PRow+StRow
		    
		  }
		}
		if (bdprn==false){
	      if (Res=="") 
	      {
            Res= "0|0";
	      }
          PageStr=Res.split("|");
          StPage=PageStr[0];
	      StRow=PageStr[1];
		}
		if ((PrTyp==1)||(PrTyp==2)){
		   StPage=1;
	       StRow=1;
        }

		var ret
		var rows;
		if(PrTyp==2){
			starti=Number(btOffset)+1
			//num=Number(btOffset)+Number(btLimit)
			num=Number(btOffset)+Number(PRow)
			num=$('#phypreshetb').dhccTableM('getData').length //huaxiaoying 2017-01-18
		}
		len=Number(num)+1

		//alert(len+"^"+starti)
		currow=1
		for (i=starti;i<len;i++)
	     {  
		   var res=serverCall( "web.DHCEMPhysiOreSheet", "GetItem",{ 'i':i,'Adm':EpisodeID,'strj':strj});//cspRunServerMethod(GetItem,i,Adm,strj);
		   
		   var data=res.split("^");
		   currow+=1;
		   xfillgrid(xlsSheet,data,currow);


		   Pres=(currow)%PRow;
		   if((Pres=0)||(i==num)){
		   	   gridset(xlsSheet,1,1,cols,1,9);
			   gridlist(xlsSheet,1,PRow,1,cols);
			   titlegrid(xlsSheet,PageNum);
			   PageNum+=1;
			   currow=1;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);
		   }
		   continue;
		   
           if (PrTyp==2){
	           //��ӡ��ǰҳ
             if(i<Number(btOffset)+1)continue
             if(i>Number(btOffset)+Number(btLimit))continue

           }
		   if (((StPage==PageNum)&&(frw>=StRow))||(PageNum>StPage))
		   {

			 frw+=1; 
		     xfillgrid(xlsSheet,data,frw);
		     Print=true;
		   }
		   else
		   {
		      frw+=1;
		   			   	////////////////ͣ����ҽ����ӡǩ��070406qse
		       if (((StPage==PageNum)&&(frw<StRow)))
		       {
			    Print=true;
			    lsFillData(frw ,data, xlsSheet);
		       }
		   }
		   Pres=(frw)%PRow;
		   //
		   //(frw+"^"+Pres)
		   if (Pres==0)
		   {
			  if (StPage>=PageNum)
			  {
                if (StRow==1) // + "����"��"����"�Ľ� 090310
		     	{
			     	if (PrTyp==0)
			        {
				      	if (PageNum>=StPage)  
				          {
					          gridset(xlsSheet,1,1,cols,1,9);
            	           	  gridlist(xlsSheet,1,PRow,1,cols);
			               	  titlegrid(xlsSheet,PageNum);       
				          }
 			        } 
			     	else        			    
		           	{
			          	if ((PrTyp==1)||(PrTyp==2))
			         	{ 
			         		gridset(xlsSheet,1,1,cols,1,9);
            	      		gridlist(xlsSheet,1,PRow,1,cols);
			                titlegrid(xlsSheet,PageNum);
			            }      
		            }
                 } 
			  }
			  else
			  {
			    gridset(xlsSheet,1,1,cols,1,9);
			    gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
			  }
			   PageNum+=1;
			   frw=1;
               xlsSheet.PrintOut;
               ClearContents (xlsSheet,ClearStr);
		   } 
		 }
        if (frw>1)
        {
	        if ((StPage==PageNum)&&(frw>1)&&(StPage!=0))
	        {
		      if (StRow==1)
		      {	
		        gridset(xlsSheet,1,1,cols,1,9);
          		gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);
              }
		    }
		    else
		    {
			    gridset(xlsSheet,1,1,cols,1,9);
            	gridlist(xlsSheet,1,PRow,1,cols);
			    titlegrid(xlsSheet,PageNum);

			}
			 if (Print==true)
			 {
             xlsSheet.PrintOut;
			 }
	    }
	    if (bdprn==false){
        SavePageRow("lsord",PageNum,frw,Dep,DepNo);
        
        var CurStat=$('#CurStatus').val();//document.getElementById("CurStatus");
        frw=frw-1;
        CurStat='����ӡ�ѵ���'+PageNum+'ҳ'+frw+'��';

	    }

        xlsSheet = null;
        xlsBook.Close(savechanges=false);
        xlsBook = null;
        xlsExcel.Quit();
        xlsExcel = null;
        //window.setInterval("Cleanup();",1); 
        //alert(1);
	}catch(e){
		alert(e.message)	
	}   
}
function ExeQuery(ExeLongQuery,Adm,Dep,user)
{   
	var prj;
	prj=cspRunServerMethod(ExeLongQuery,Adm,Dep,user);
	return prj;
}
function GetStPage(OrdTyp, Adm, Dep,depNo)
{
	var ret=serverCall( "web.DHCEMPhysiOreSheet", "GetStartPage",{ 'typ':OrdTyp,'adm':Adm,'Dep':Dep,'depNo':depNo});
	if (ret=="") ret=1;
	return ret;
}
  function SavePageRow(typ,Page,Row,Dep,DepNo)
{
	var info;
    var pagenum;
    pagenum=Page.toString();
    //typ As %String, adm As %String, page As %String, strow As %String, Dep As %String, depno As %String	
    info=serverCall( "web.DHCEMPhysiOreSheet", "startrow",{ 'typ':typ,'adm':EpisodeID,'page':pagenum,'strow':Row,'Dep':Dep,'depno':DepNo});
} 
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}
function lsFillData(Row , itm , objectxsl ) //��ʱҽ��
{   
	var flag;
	var a43, a54, a65 ;
	var skg;
	flag = fetchordflag("lsord", itm[7])
	if (flag =="Y^Y^Y") 
	return;
	// alert(flag);
	var arr=flag.split("^");         
	a43 =arr[0];
	a54 =arr[1];
	a65 =arr[2];
	if (a43=="Y") 
	{
	}
	else
	{    
		var str=itm[2];
		if (str.search("DC")!=-1)
		{
			// alert(itm[2])
			var j;

			skg="";
			//alert(skg)
			for (j=1;j<34;j++)
			{
				skg=skg+" ";
			}

			objectxsl.Cells(Row, 3).value = skg+"----DC";
			// alert(skg)
			//arratem(addnum) = Row
			//addnum = addnum + 1
			a43 = "Y"
		}
	}
	if (a54=="Y")
	{
	}
	else
	{   
		objectxsl.Cells(Row, 5).value = itm[5];
		if (itm[4]!="") 
		{
			a54 = "Y";
		}
		}
		if(a65=="Y")
		{
		}
		else
		{
			objectxsl.Cells(Row, 6).value = itm[6];
			// objectxsl.Cells(Row, 7).value = itm[6];
		if (itm[6]!="") 
		{
			a65 = "Y";
		}
	}

	flag = a43 + "^" + a54 + "^" + a65;
	saveordno("lsord", itm[7], flag);
} 
function xfillgrid(xlsSheet,itm,frw)
{
	var a43,a54,a65,flag;
	xlsSheet.cells(frw,1)=itm[0];
	xlsSheet.cells(frw,2)=itm[1];
	xlsSheet.cells(frw,3)=itm[2];
	xlsSheet.cells(frw,4)=itm[3];
	xlsSheet.cells(frw,5)=itm[5];
	xlsSheet.cells(frw,6)=itm[6];
	//xlsSheet.cells(frw,7)=itm[6];
	//alert (itm[8]);
	var str1=itm[8];
	var inx=str1.indexOf("DC",0);
	//alert(inx)
	if(inx!=-1)
	{
		a43 = "Y";
	}
	else
	{
		a43 = "N";
	}
	if (itm[4]=="") 
	{
		a54 = "N";
	}
	else
	{
		a54 = "Y";
	}
	if (itm[6]=="")
	{
		a65 = "N";
	}
	else
	{
		a65 = "Y";
	}
	flag = a43 + "^" + a54 + "^" + a65;
	saveordno("lsord", itm[7], flag);

}
function saveordno(typ,ord ,flag )
{
	var ford=ord.replace(String.fromCharCode(1), "||");
	var info=serverCall( "web.DHCEMPhysiOreSheet", "saveordno",{ 'typ':typ,'ordno':ford,'flag':flag});//cspRunServerMethod(GetItem,i,Adm,strj);
}

function titlegrid(xlsSheet,PagNum)
{       var titleRows = 0;titleCols = 0 ;//&chr(10)
		var CenterHeader = "&14"+""+"\r"+"";
		//web.DHCCLCom.PatInfo
	    var info=serverCall( "web.DHCCLCom", "PatInfo",{'curId':"^"+EpisodeID});
	    var infoarr=info.split("^");
	    //web.DHCEMPhysiOreSheet.getmother
	    var motherRegNo=serverCall( "web.DHCEMPhysiOreSheet", "getmother",{'adm':EpisodeID});
	    var mother=""
        if (motherRegNo!="")
        {
	        mother="mother:"+motherRegNo;
	    }
		//regno_"^"_ctloc_"^"_room_"^"_sex_"^"_patName_"^"_Bah_"^"_bedCode_"^"_age
	    //var  LeftHeader="\r\r\r&9"+t['val:patname']+":"+infoarr[4]+"    "+t['val:Dep']+infoarr[1]+"     "+t['val:bed']+infoarr[6]+"      "+t['val:regNo']+infoarr[0]+"  "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
	    var  LeftHeader="\r\r\r&11"+"   "+'����'+":"+infoarr[8]+"   "+'����'+infoarr[6]+"   "+'����'+":"+infoarr[4]+"   "+'סԺ��:'+infoarr[5]+"   "+'�ǼǺ�: '+infoarr[0];LeftFooter = "";CenterFooter = '&10�� &P ҳ';RightFooter = "";
	    //var  LeftHeader="\r\r\r&9    "+t['val:patname']+":"+infoarr[4]+"              "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        LeftFooter = "";CenterFooter = '&10�� &P ҳ';RightFooter = "";
        hospitalDesc=serverCall( "web.DHCCLCom", "GetHospital");
	    var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+'�� ʱ ҽ �� ��';
	    
	    
	     var RightHeader = " ";LeftFooter = "";//RightFooter ="&10"+t['val:nurseSign']+""+"\r"+t['val:docSign']+" "; ;LeftFooter = "";
	    var CenterFooter ="\r\r\r\r&10                                   "+'��'+PagNum+'ҳ'+"                  "+"&10"+'��ʿǩ��'+""+"\r"+"                                                          "+'ҽ��ǩ��'+" ";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}      

