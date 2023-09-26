/// Creator: congyue
/// CreateDate: 2016-08-11
///  Descript: 医嘱单

var TagCode="",CategoryRowId="",Dep=1;
var BPRNSTR="";
var hospitalDesc;
var btOffset; //开始条数
var btLimit;  //一页的行数
var btTotal; //总行数
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
    //开始日期
    $('#StDate').dhccDate();
	//$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))	
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 日期格式走配置
				function(data){
					if(data==3){
						$("#StDate").setDate(new Date().Format("yyyy-MM-dd"))
				    }else if(data==4){
					    $("#StDate").setDate(new Date().Format("dd/MM/yyyy"));
					}else{
						return;
					}
				});
    //结束日期
    $('#EndDate').dhccDate();
	//$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},  //hxy 2017-03-08 日期格式走配置
				function(data){
					if(data==3){
						$("#EndDate").setDate(new Date().Format("yyyy-MM-dd"))
				    }else if(data==4){
					    $("#EndDate").setDate(new Date().Format("dd/MM/yyyy"));
					}else{
						return;
					}
				});	
	//复选框分组
	InitUIStatus();
	//复选框按钮事件 xiugai lvpeng 2016-12-29
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

	$("#queryBtn").on('click',function(){	//查询按钮事件
		search();
	})
	
	//医嘱单列表 
    $('#phypreshetb').dhccTable({
	    formatShowingRows:function(pageFrom, pageTo, totalRows){
		    return "第 "+pageFrom+" 到第 "+pageTo+" 条记录，共 "+totalRows+" 条记录"+"<div id='pageTo' style='display:none'>"+totalRows+"</div>"
		},//huaxiaoying 2017-01-17
	    height:window.parent.tabHeight-95,
	    pageSize:200,//每页显示行数
        idField: 'id',
        url: 'dhcapp.broker.csp?ClassName=web.DHCEMPhysiOreSheet&MethodName=QueryGetTempOrdInfo', ///"10"
        columns: [{
			field: 'OerdDate',
			title: '开始日期',
			align: 'center'
		}, {
			field: 'OerdTime',
			title: '开始时间',
			align: 'center'
		}, {
			field: 'Doctor',
			title: '医生',
			align: 'center'
		},  {
			field: 'ARCIMDesc',
			title: '医嘱描述',
			formatter:orderName,
			align: 'center'
		}, {
			field: 'seqNo',
			title: '医嘱序号',
			align: 'center'
		},{
			field: 'DateEx',
			title: '执行日期',
			align: 'center'
		}, {
			field: 'TimeEx',
			title: '执行时间',
			align: 'center'
		}, {
            field: 'ExDC',
            align: 'center',
            title: '执行人'
        },{
            field: 'DisposTime',
            align: 'center',
            title: '处理时间'
        }, {
            field: 'DisposNur',
            align: 'center',
            title: '处理人'
        },  {
            field: 'ORW',
            align: 'center',
            title: 'ORW'
        }, {
            field: 'ProcessNo',
            align: 'center',
            title: '进程号'
			
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
/// Title列内容样式修改
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
		findLong();	//长嘱
	}if($('#OrdTemp').attr('checked')=="checked"){
		Temp_click(); //临嘱
	}if($('#SelDate').is(':checked')){
		//开始日期
    	StDate=$('#StDate input').val();
    	//结束日期
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("请选择开始日期与结束日期");
			return;   //ssuser
		}
		$('#phypreshetb').dhccQuery({
		query:{
			//Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"长期医嘱"
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
			//Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"长期医嘱"
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
///长期医嘱
function findLong()
{
    var RegNo=RegNo;  
    var AdmCom=EpisodeID;  
    var Adm=EpisodeID;
    var ssuser="";
    var StDate="",EndDate="";
    //按日期查询
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;
		}
	})
	if (SelDate==1){
		//开始日期
    	StDate=$('#StDate input').val();
    	//结束日期
    	EndDate=$('#EndDate input').val();
		if ((StDate=="")||(EndDate==""))
		{
			alert("请选择开始日期与结束日期");
			return;   //ssuser
		}
	}
    //全部
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //护嘱
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //医嘱
    var DocOrd =0;
    $("input[type=checkbox][name=DocOrd]").each(function(){
		if($(this).is(':checked')){
			DocOrd =this.value;
		}
	})
  	$('#phypreshetb').dhccQuery({
		query:{
			Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"长期医嘱"
			}
	}) 
}
///临时医嘱
function Temp_click()
{
    var RegNo=RegNo;  
    var AdmCom=EpisodeID;  
    var Adm=EpisodeID;
    var ssuser="";
    var StDate="",EndDate="";
    if ((Adm=="")) {alert(t['alert:EpisodeIDNull']);return false;};
    //按日期查询
    var SelDate =0;
    $("input[type=checkbox][name=SelDate]").each(function(){
		if($(this).is(':checked')){
			SelDate =this.value;
		}
	})
	if (SelDate==1){
		//开始日期
    	StDate=$('#StDate').getDate();
    	//结束日期
    	EndDate=$('#EndDate').getDate();
		if ((StDate=="")||(EndDate==""))
		{
			alert("请选择开始日期与结束日期");
			return;   //ssuser
		}
	}
    //全部
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //护嘱
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //医嘱
    var DocOrd =0;
    $("input[type=checkbox][name=DocOrd]").each(function(){
		if($(this).is(':checked')){
			DocOrd =this.value;
		}
	})
  	$('#phypreshetb').dhccQuery({
		query:{
			Adm:Adm,StartDate:StDate,EndDate:EndDate,stop:AllOrd,ssuser:ssuser,NurOrd:NurOrd,DocOrd:DocOrd,OrdType:"临时医嘱"
			}
	}) 
}

///打印当前
function PrintCurrClick()
{
	XPrintClick(2);
	return;

}
///打印
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
		var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //获取数据行数
	    var PRow=28;//lines per pages
	    var pnum=0; //pages
	    var frw=2;
		for (i=1;i<num+1;i++) //分行打印
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
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+'临 时 医 嘱 单';
	    var info=serverCall( "web.DHCCLCom", "PatInfo",{'curId':RegNo+"^"+EpisodeID});
	    
	    var infoarr=info.split("^");
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+'姓名'+":"+infoarr[4]+"    "+'科别:'+infoarr[1]+"     "+'病室'+infoarr[2]+"      "+'登记号: '+infoarr[0];LeftFooter = "";CenterFooter = '&10第 &P 页';RightFooter = "";
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
	 xlsSheet.cells(frw,1)='日期';
	 xlsSheet.cells(frw,2)='时间';
	 xlsSheet.cells(frw,3)='医嘱名称';
	 xlsSheet.cells(frw,4)='医生签名';
	 xlsSheet.cells(frw,5)='执行时间';
	 xlsSheet.cells(frw,6)='护士签名';
	 xlsSheet.cells(frw,7)='备注';


}
function GetFilePath()
{   
	//1、获取XLS导出路径
	var path=serverCall( "web.DHCLCNUREXCUTE", "GetPath");
    return path;
}
//补打医嘱
function PrintSet()
{
	var StPage=$('#StPage').val();
	var StRow=$('#StRow').val();
	var EdPage=$('#EdPage').val();
	var EdRow=$('#EdRow').val();
	var PRow=28;//每页行数
	var page=Math.ceil(btTotal/PRow);
	if((StPage=="")||(StRow=="")||(EdPage=="")||(EdRow=="")){
		alert("输入项不能为空,请重新输入!");
		return;
	}
	
	if((isNaN(StPage)==true)||(isNaN(StRow)==true)||(isNaN(EdPage)==true)||(isNaN(EdRow)==true)){
		alert("输入项有误,请重新输入!");
		return;
	}

	if((StPage>page)||(EdPage>page)||(StPage>EdPage)){
	   alert("页数输入有误,请重新输入!");
	   return;
	}
	if((StRow>PRow)||(EdRow>PRow)){
	   alert("行数输入有误,请重新输入!");
	   return;
	} 
	if(StRow>$('#pageTo').html()){  //huaxiaoying 2017-01-17
	   dhccBox.alert("开始行不能大于行总数"+$('#pageTo').html()+" !","sheet-two");
	   return;
	} 
	if(EdRow>$('#pageTo').html()){  //huaxiaoying 2017-01-17
	   dhccBox.alert("结束行不能大于行总数"+$('#pageTo').html()+" !","sheet-one");
	   //alert("结束行不能大于行总数"+$('#pageTo').html()+" !");
	   return;
	} 
   var str=StPage+"|"+StRow+"|"+EdPage+"|"+EdRow;

   BPRNSTR=str;
   XPrintClick(0);

}

//打印预览
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
		var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //获取数据行数
	    var PRow=28;//lines per pages
	    var pnum=0; //pages
	    var frw=2;
		for (i=1;i<num+1;i++) //分行打印
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
		var CenterHeader = "&12"+hospitalDesc+"\r"+"&14"+'临 时 医 嘱 单';
	    var info=serverCall( "web.DHCCLCom", "PatInfo",{'curId':RegNo+"^"+EpisodeID});
	    var infoarr=info.split("^");
	    var RightHeader="";
	    var  LeftHeader="\r\r\r&9"+'姓名'+":"+infoarr[4]+"    "+'科别:'+infoarr[1]+"     "+'病室'+infoarr[2]+"      "+'登记号: '+infoarr[0];LeftFooter = "";CenterFooter = '&10第 &P 页';RightFooter = "";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        var sherow=PRow-(i-pnum*PRow);
		gridlist(xlsSheet,1,i+sherow,1,7);
		xlsExcel.Visible = true;
        xlsSheet.PrintPreview ;
}
function PageBtn_Click()
{
	//页码
	var PagNo=$('#PagNo').val();  //var page=document.getElementById("PagNo").value;
	//就诊id
	var Adm=EpisodeID;  //var adm=document.getElementById("Adm").value;
	var ssuser="";
 	var pageNum;
	if (PagNo!="")
	{
		pageNum=eval(PagNo)-1
	}else{
		return;
	}
    //全部
    var AllOrd =0;
    $("input[type=checkbox][name=AllOrd]").each(function(){
		if($(this).is(':checked')){
			AllOrd =this.value;
		}
	})    
    //护嘱
    var NurOrd =0;
    $("input[type=checkbox][name=NurOrd]").each(function(){
		if($(this).is(':checked')){
			NurOrd =this.value;
		}
	})
    //医嘱
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
	   var truthBeTold = window.confirm('查看打印机有没有其它打印作业单击?确定?继续?单击?取消?停止?');
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
	    var num=serverCall( "web.DHCEMPhysiOreSheet", "GetItemNum",{ 'Adm':EpisodeID,'strj':strj}); //获取数据行数
	    //察看打印的页码和行数
	    var Res,TmpRes;
	    var Print;
	    var StPage=0,EdPage=0;
	    var StRow=0,EdRow=0;
	    var PageStr;
        var bdprn;
        var PRow=28;//每页行数
	    var pnum=0; //页数
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
 	    {  //补打设置
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
	           //打印当前页
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
		   			   	////////////////停过的医嘱打印签名070406qse
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
                if (StRow==1) // + "续打"或"补打"改进 090310
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
        CurStat='续打印已到第'+PageNum+'页'+frw+'行';

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
function lsFillData(Row , itm , objectxsl ) //临时医属
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
	    var  LeftHeader="\r\r\r&11"+"   "+'病区'+":"+infoarr[8]+"   "+'床号'+infoarr[6]+"   "+'姓名'+":"+infoarr[4]+"   "+'住院号:'+infoarr[5]+"   "+'登记号: '+infoarr[0];LeftFooter = "";CenterFooter = '&10第 &P 页';RightFooter = "";
	    //var  LeftHeader="\r\r\r&9    "+t['val:patname']+":"+infoarr[4]+"              "+t['val:Dep']+infoarr[1]+"                "+t['val:bed']+infoarr[6]+"              "+t['val:patRec']+infoarr[12];LeftFooter = "";CenterFooter = t['val:cFooter'];RightFooter = "";
        LeftFooter = "";CenterFooter = '&10第 &P 页';RightFooter = "";
        hospitalDesc=serverCall( "web.DHCCLCom", "GetHospital");
	    var CenterHeader = "&15"+hospitalDesc+"\r"+"&18"+'临 时 医 嘱 单';
	    
	    
	     var RightHeader = " ";LeftFooter = "";//RightFooter ="&10"+t['val:nurseSign']+""+"\r"+t['val:docSign']+" "; ;LeftFooter = "";
	    var CenterFooter ="\r\r\r\r&10                                   "+'第'+PagNum+'页'+"                  "+"&10"+'护士签名'+""+"\r"+"                                                          "+'医生签名'+" ";
        ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter) 
        //PrintPagNo(xlsSheet,PagNum,11,24)
}      

