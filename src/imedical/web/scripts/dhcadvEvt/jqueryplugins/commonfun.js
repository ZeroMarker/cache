function GetRequest() {

   var url = location.search;//��ȡurl��"?"������ִ�
   

   var theRequest = new Object();

   if (url.indexOf("?") != -1) {

      var str = url.substr(1);

      strs = str.split("&");

      for(var i = 0; i < strs.length; i ++) {
		  

         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);

      }

   }

   return theRequest;

}



//����js liangqiang 2014-05-20
function ImportJavaScript(url)
{

	  	var script=document.createElement("script");  
		script.setAttribute("type", "text/javascript");  
		script.setAttribute("src", url);  
		var heads = document.getElementsByTagName("head");
		if(heads.length) 
		{
			 heads[0].appendChild(script); 
		} 
		    
		else  {
			document.documentElement.appendChild(script);
		}

}

//����CSS liangqiang 2014-05-20
function ImportCssByLink(url){  
   var doc=document;  
    var link=doc.createElement("link");  
    link.setAttribute("rel", "stylesheet");  
    link.setAttribute("type", "text/css");  
    link.setAttribute("href", url);  
  
    var heads = doc.getElementsByTagName("head");  
    if(heads.length)  
        heads[0].appendChild(link);  
    else  
        doc.documentElement.appendChild(link); 

     
}


//����JqueryUI��ػ��� liangqiang 2014-05-27
function ImportJqueryUI()
{
    
    var url="../scripts_lib/jquery-easyui-1.3.5/jquery-1.7.2.min.js"
	ImportJavaScript(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/jquery.easyui.min.js"
    ImportJavaScript(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/themes/default/easyui.css"
	ImportCssByLink(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/themes/icon.css"
	ImportCssByLink(url)
	var url="../scripts_lib/jquery-easyui-1.3.5/locale/easyui-lang-zh_CN.js"
    ImportJavaScript(url)

}

/// ��ȡ����  bianshuai 2014-09-18
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

/// ��ʽ������  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	
	if(typeof(DateFormat)=="undefined"){//2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){//���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){//���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){//���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{//2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

/// ��ʽ������  yangyongtao 2017-11-17
function formatDateD(t){
	
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	//var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	if(typeof(DateFormat)=="undefined"){//2017-03-15 cy
		return Year+"-"+Month+"-"+"01";
	}else{
		if(DateFormat=="4"){//���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return "01"+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){//���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+"01";
		}else if(DateFormat=="1"){//���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+"01"+"/"+Year;
		}else{//2017-03-15 cy
			return Year+"-"+Month+"-"+"01";
		}
	}
}
//�滻������� 2014-07-25 bianshuai
function trSpecialSymbol(str)
{
	if(str.indexOf("%")){
		var str=str.replace("%","%25");
	}
	if(str.indexOf("&")){
		var str=str.replace("&","%26");
	}
	if(str.indexOf("+")){
		var str=str.replace("+","%2B");
	}
	return str;
}

/// Ĭ����ʾ���������
function initScroll(dg){
	var opts=$(dg).datagrid('options');    
	var text='{';    
	for(var i=0;i<opts.columns.length;i++)
	{    
		var inner_len=opts.columns[i].length;    
		for(var j=0;j<inner_len;j++)
		{    
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
	$(dg).datagrid('loadData',data);  
	$("tr[datagrid-row-index='0']").css({"visibility":"hidden"});
}

/*
LiangQiang 2014-08-08
���Ƶ���Div����,Ĭ���Ǵ�Ʒ��Ŀ�б�
*/
var CreatMyDiv=function (input,tarobj,mydivid,mydivw,mydivh,mytblid,mycols,mydgs,mydgid,mydesc,fn)
{
	this.input=input;//���
	this.tarobj=tarobj;//Ŀ��Դ
	this.mydivid=mydivid;//
	this.mydivw=mydivw;
	this.mydivh=mydivh;
	this.mytblid=mytblid;
	this.mycols=mycols;
	this.mydgs=mydgs;
	this.fn=fn;
}

CreatMyDiv.prototype={ 
	init:function(){
	   var input=this.input;
	   var tarobj=this.tarobj;
	   var mydivid=this.mydivid;
	   var mydivw=this.mydivw;
	   var mydivh=this.mydivh;
	   var mytblid=this.mytblid;
	   var mycols=this.mycols;
	   var mydgs=this.mydgs;
	   var fn=this.fn;

	   var rowIndex="";

       if((input.length)==0){
		   //return;
	   }

       RemoveMyDiv();

       $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
	   $("#"+mydivid).append('<div id='+mytblid+'></div>');

       var mydiv=$("#"+mydivid);
	   
	   mydiv.show();			  
	   mydiv.css("left",tarobj.offset().left);
	   if(mydivh<tarobj.offset().top){
	       mydiv.css("top",tarobj.offset().top-mydivh);//divλ�� ���ϵ���
	   }else
	   {
		   mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());//divλ��
	   }
		$("#"+mydivid).css({"z-index":"2"});//2018-10-25 �������ı�������ϲ�

      
	  
	   if (mycols=='')
	   {
		   mycols = [[
				{field:'InciCode',title:'����',width:60}, 
				{field:'InciDesc',title:'����',width:220}, 
				{field:'Spec',title:'���',width:80},
				{field:'ManfName',title:'����',width:80},
		   ]];
	  }

	  if (mydgs=='')
	  {
			mydgs = {
				url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
				columns: mycols,//����Ϣ
				pagesize:10,//һҳ��ʾ��¼��
				table: '#drugsgrid',//grid ID
				field:'InciCode',//��¼Ψһ��ʶ
				params:null,// �����ֶ�,��Ϊnull
				tbar:null,//�Ϲ�����,��Ϊnull
				NullMsgs:""
			}
	  }

      var gridobj = new DataGrid(mydgs);
      gridobj.init();


	      //���÷�ҳ�ؼ�  

			var p = $("#"+mytblid).datagrid('getPager');  

			$(p).pagination({  

				buttons: [{
						text:'�ر�',
						handler:function(){
						RemoveMyDiv();
						fn('');
						}
					}]


			});

      var mygrid=$("#"+mytblid);
	  mygrid.datagrid('getPanel').panel('panel').attr("tabindex",0);
      mygrid.datagrid('getPanel').panel('panel').focus() ;

	  var opt=mygrid.datagrid('options');
	   opt.onClickRow=function(rowIndex, rowData){
		   //var admrowid=mygrid.datagrid('getSelected').Adm ;
		   RemoveMyDiv();
		   fn(rowData);
		   return;
	   }



	  //mygrid.gridupdown(mygrid);
	  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
		
        switch (e.keyCode) {
        case 13: // enter
		if (event && event.preventDefault){//�ر�Ĭ����Ϊ qunianpeng 2018/1/17
		event.preventDefault();
		}else{
			window.event.returnValue=false;  
		}
		   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
		var rowData=mygrid.datagrid('getSelected');
		   rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
		   RemoveMyDiv();
		//fn(InciDesc,PhcdfDr);
		fn(rowData);		//qunianpeng 2018/1/17
		break ;
		//return ;
		   
        case 27:  //Esc

		   RemoveMyDiv();
		   fn('');
				break ;
				//return;
			/*case 33:  //Page Up
		   		var rowData = mygrid.datagrid('getSelected');
		   		var currRowIndex = mygrid.datagrid('getRowIndex',rowData);
		   		if (currRowIndex - 1 >= 0){
		   			mygrid.datagrid("selectRow",currRowIndex - 1);
		   		}
		   		break;
		   	case 34:  //Page Down
		   		var rows = mygrid.datagrid('getRows');
		   	    var rowData = mygrid.datagrid('getSelected');
		   		var currRowIndex = mygrid.datagrid('getRowIndex',rowData);
		   		if (currRowIndex + 1 <= rows.length){
		   			mygrid.datagrid("selectRow",currRowIndex + 1);
		   		}
		   		break;
		   	*/
		    case 38:  //Page Up
		    	if (event && event.preventDefault){//qunianpeng 2018/1/17
			    	event.preventDefault();
			    }else{
					window.event.returnValue=false;  
				}
		    	var rowData = mygrid.datagrid('getSelected');
		   		var currRowIndex = mygrid.datagrid('getRowIndex',rowData);
		   		if (currRowIndex - 1 >= 0){
		   			mygrid.datagrid("selectRow",currRowIndex - 1);
		   		}
		   		break;
		   	case 40:  //Page Down					//qunianpeng 2018/1/17 
		  	 	if (event && event.preventDefault){
			    	event.preventDefault();
			    }else{
					window.event.returnValue=false;  
				}
		   		var rows = mygrid.datagrid('getRows');
		   	    var rowData = mygrid.datagrid('getSelected');
		   		var currRowIndex = mygrid.datagrid('getRowIndex',rowData);
		   		if (currRowIndex + 1 < rows.length){
		   			mygrid.datagrid("selectRow",currRowIndex + 1);
		   		}
		   		break;
			}
		})
		/* mygrid.datagrid('getPanel').panel('panel').blur(function() { 
			if (rowIndex=="")
			{
				//alert(1)
				//RemoveMyDiv();
				//fn('');
			}   
		}); */

	  //���
	  function RemoveMyDiv()
	  {
		if($("#"+mydivid).length>0)
		   {
			   $("#"+mydivid).remove(); 
			   $("#"+mytblid).remove(); 
		   }
	  } 
	}
}



///��ȡ��һ��ʱ��
function getBeforeYearDate(){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Day+"-"+Month;
}


function curTime(){
	var curr_Date = new Date();  
	return curr_Date.getHours()+":"+curr_Date.getMinutes()+":"+curr_Date.getSeconds();	
}

//����·��ѡ��� 2017-12-22 �������
function browseFolder()
{  
  try {  
	  var Message = "��ѡ��·��";//ѡ�����ʾ��Ϣ  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//��ʼĿ¼Ϊ���ҵĵ���  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items();// ���� FolderItems ����  
		  Folder = Folder.item();// ���� Folderitem ����  
		  Folder = Folder.Path;// ����·��  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }  
  catch(e) 
  {  
	  //alert(e.message);  
  }  
}


function GetGridOpt(grid)
{
	var opt=$(grid).datagrid('options');
	return opt
}

/// ����ַ���
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];/// ��ʼ��������
	var Len = 0; j = 0; k = 0;
	/// bianshuai  ��ȡҩ��
	for (var i=0; i<TmpString.length; i++) {
		var vChar = TmpString.charCodeAt(i);   
		//���ֽڼ�1    
		if ((vChar >= 0x0001 && vChar <= 0x007e)||(0xff60 <= vChar && vChar <= 0xff9f)){   
			Len++;   
		}else{   
			Len+=2;   
		}
		
		if(((Len%LimitLen == 0)||(Len%LimitLen == 1))&(Len != 1)){
			
			if ((i - k) < 2) continue;
			TmpLabelArr[j] = TmpString.substr(k, i-k);  /// ��ȡ�ַ���
			if (j == 4){
				TmpLabelArr[j] = TmpLabelArr[j] + "...";   /// ���һ���ַ��������...
				break;
			}
			j = j + 1;
			k = i;
		}
		if ((i == TmpString.length - 1)&(k != i)){
			TmpLabelArr[j] = TmpString.substr(k, (i-k)+1);
		}
	}
	return TmpLabelArr;
}

/**ȥ���ַ���ǰ�����пո�*/
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
}

//��������ѡ�񲻵ó�������	2018-05-30 cy
function chkdate(id,timeid){
	var datevalue=$('#'+id).datebox('getValue');
	$('#'+id).datebox({editable:false});
	$('#'+id).datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	if(datevalue!=""){
		$('#'+id).datebox('setValue',datevalue);	
	}
	// �������� ��ѡ�Զ���¼ ��������
	if((timeid!="")&&(timeid!=undefined)&&($("input[id^='"+timeid+"']").length>0)){
		$('#'+id).datebox({
		    onSelect: function(date){
			    var SelDate="";
				var Reltiem=$("#"+timeid).val();   //sufan  2019-11-12  ѡ������ʱ�ж��·���ʱ��
				var Year = date.getFullYear();
				var Month = date.getMonth()+1;
				var Day = date.getDate();
				
				if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
					SelDate=  Year+"-"+Month+"-"+Day;
				}else{
					if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
						SelDate= Day+"/"+Month+"/"+Year;
					}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
						SelDate= Year+"-"+Month+"-"+Day;
					}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
						SelDate= Month+"/"+Day+"/"+Year;
					}else{ //2017-03-15 cy
						SelDate= Year+"-"+Month+"-"+Day;
					}
				}
				
				// ����ʱ��Ƚ�
				var DateFlag="";
				runClassMethod("web.DHCADVCOMMON","DateTimeCompare",{'Date':SelDate,'Time':Reltiem},
					function(data){
						DateFlag=data;
				},"text",false);
				if(DateFlag==1){
					$.messager.alert("��ʾ:","����������ʱ����ڵ�ǰʱ�䣡��������дʱ��");
					$("#"+timeid).val("");
				}
				
				/* if ((new Date(date).toDateString() === new Date().toDateString())&&(Reltiem!="")) {	
					var seletime=Reltiem.replace(":","").valueOf();
					var nowhour=new Date().getHours();
					if(nowhour<10){
						nowhour="0"+nowhour;
					}
					var nowitme=new Date().getMinutes();
					if(nowitme<10){
						nowitme="0"+nowitme;
					}
					var currtime=(nowhour+""+nowitme).valueOf();
					if(seletime>currtime){
						$.messager.alert("��ʾ:","����������ʱ����ڵ�ǰʱ�䣡��������дʱ��");
						$("#"+timeid).val("");
					}
				} */
		    }
		})
	}
	
} 
//����Ԫ�ظ�ֵ  2018-05-30 cy
//���: id:Ԫ��id, type:Ԫ������(input,radio,checkbox,datebox,combobox), value:Ԫ������ֵ
function RepSetValue(id,type,value){
	if((type=="input")||(type=="textarea")){
		$('#'+id).val(value); 
	}else if((type=="radio")||(type=="checkbox")){
		$("input[type="+type+"][id^='"+id+"']").attr("disabled",false);
		$("input[type="+type+"][id^='"+id+"'][value='"+value+"']").click(); 
	}else if((type=="combobox")){
		//$('#'+id).combobox({disabled:false});  
		$('#'+id).combobox('setValue',value); 
	}else if((type=="datebox")){
		///$('#'+id).datebox({disabled:false}); 
		$('#'+id).datebox('setValue',value);
	}
}
//����Ԫ���Ƿ���Ա༭ 2018-05-31 cy
//���: id:Ԫ��id, type:Ԫ������(input,radio,checkbox,datebox,combobox), readflag: �༭��ʶ 0��� ���Ա༭,1 ���ɱ༭
function RepSetRead(id,type,readflag){
	if((type=="input")||(type=="textarea")){
		if(readflag==1){
			$('#'+id).attr("readonly","readonly"); 
		}else{
			$('#'+id).attr("readonly",false);
		}
	}else if((type=="radio")||(type=="checkbox")){
		if(readflag==1){
			$("input[type="+type+"][id^='"+id+"']").attr("disabled",true);  
		}else{
			$("input[type="+type+"][id^='"+id+"']").attr("disabled",false); 
		}
	}else if((type=="combobox")){
		if(readflag==1){
			$('#'+id).combobox({disabled:true});
		}else{
			$('#'+id).combobox({disabled:false});  
		}
	}else if((type=="datebox")){
		var value=$('#'+id).datebox('getValue');
		if(readflag==1){
			$('#'+id).datebox({disabled:'true'});  
		}else{
			$('#'+id).datebox({disabled:false}); 
			if(value!=""){
				$('#'+id).datebox('setValue',value);	
			}  
		}
	}
}
//���ƿ������������ ���ϼ����룬����ֵ����	2018-06-06 cy
function chkcombobox(id,url){
	var value=$('#'+id).combobox('getValue');
	$('#'+id).combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //���������������
		onShowPanel:function(){ 
			$('#'+id).combobox('reload',url)
		}
	});
	if(value!=""){
		$('#'+id).combobox('setValue',value);	
	}
} 
//��ȡ�������ͣ�Ԫ�����Ͷ��ڣ����ڣ��������������յȵȣ� 2018-06-13 cy
function QueryDateType(date){
	var DateType="";
	runClassMethod("web.DHCADVCOMMONPART","QueryDateType",{'Date':date},
	function(Data){
		 DateType=Data;
	},"text",false)
	return DateType;
}
//Ԫ�ص���¼���ʧȥ�����¼���change�¼�
function AllStyle(id,x,y) {
	$(""+id+"").bind('input propertychange ',function(){
	    ChangeStyle(id,this,x,y);
    });
    $(""+id+"").focus('input propertychange ',function(){
	    ChangeStyle(id,this,x,y);
    });
    var mouseflag=0;
    $("body").mouseleave(function(){
        mouseflag=1;
	});
	$("body").mousemove(function(){
        mouseflag=0;
	});
    $(""+id+"").blur('input propertychange ',function(){
	    if(id!="textarea"){
		    if(mouseflag!=1){
			   	var thisinput=this
		        setTimeout(function(){ //��ʱ�޸�body���
			        thisinput.style.width=x+'px';
			        thisinput.style.maxWidth=x+'px';
			        thisinput.style.zIndex=1;
			        $("body").width(bodywidth+'px');
			    },100)
		        
			}else{
    			this.focus();
			}
		}
		if(id=="textarea"){
		    this.style.height=y+'px';
		}
    });
    
}
//�޸�Ԫ����ʽ
function ChangeStyle(id,obj,x,y){
	if(id!="textarea"){
		var text_length = $(obj).val().length;  //��ȡ��ǰ����
        var width = parseInt(text_length)*14; //��12�Ǹı�ǰ�Ŀ�ȳ��Ե�ǰ�ַ����ĳ��ȣ����ÿ���ַ��ĳ���
        var marbodyleft=parseInt($(obj).offset().left)
        if(width>x){
	        obj.style.width=width+marbodyleft+30+'px';
	        obj.style.maxWidth=width+30+'px';
	        obj.style.zIndex=2;
	        if((width+30+marbodyleft)>bodywidth){
	        	$("body").width(width+marbodyleft+30+'px');
	        }
	    }else{
	    	obj.style.width=x+'px'
	    }
	}
	if((id=='textarea')){
		if((obj.scrollHeight>y)&&(obj.scrollHeight<($('body').height()-$(obj).offset().top+30))){
			obj.style.height = obj.scrollHeight + "px";
		}else if(obj.scrollHeight>($('body').height()-$(obj).offset().top-30)){
			 obj.style.height=$('body').height()-$(obj).offset().top-30+'px';
		}else{
			 obj.style.height=y+'px';
		}
		
	}
}
//Ԫ���·�����textarea ����� 2018-12-12
function InputDiv (id,myname,value)
{
	RemoveInputDiv(myname); 
	$(document.body).append('<div name="div'+myname+'" style="width:300px;border:1px solid #E6F1FA;position:absolute;z-Index:2"><textarea class="mytext" name="text'+myname+'" rows="10" cols="129" style="margin:2px;width:100%;">'+""+'</textarea></div>') 
	var mydiv=$("[name='div"+myname+"']"); 
	var tarobj=$("input[name='"+myname+"'][type='input']");  
	mydiv.show();
	if((tarobj.offset().left+300)>($(".dhcc-panel-body").width()+$(".dhcc-panel-body").offset().left)){
		mydiv.css("left",($(".dhcc-panel-body").width()+$(".dhcc-panel-body").offset().left-300));
	}else{
		mydiv.css("left",tarobj.offset().left);
	}
	mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());  //divλ�� label-input ���·�
	$("[name='text"+myname+"']").focus().val(value);
	
}
//���textarea ����� 2018-12-12
function RemoveInputDiv(myname){
	if($("[name='div"+myname+"']").length>0){
		$("[name='div"+myname+"']").remove();
		$("[name='text"+myname+"']").remove();
	}
} 
// .label-input�����Ĭ�ϵ����ı��� ��textarea�ı����Զ�������ʼ��
function InitLabInputText(id){
   /*  $(""+id+"").bind('input propertychange ',function(){
		InputDiv (this.parentElement.id,this.name,this.value);
	}); */
	//$(""+id+"").click('input propertychange ',function(){ //���÷�ÿ�ε���¼������ۼӣ����¼����ٶ���
	$(""+id+"").unbind('click').on('click',function(){
		InputDiv (this.parentElement.id,this.name,this.value);
	});
	$(".mytext").bind('input propertychange ',function(){
    	var inputname=this.name.replace(/text/g,"");
    	$("input[name='"+inputname+"'][type='input']").val(this.value);
 	});
 	$(".mytext").blur('input propertychange ',function(){
   	 	var inputname=this.name.replace(/text/g,"");
    	RemoveInputDiv(inputname);
 	});
}


//����ʱ��input������	2019-06-22 cy
function chktime(timeid,dateid){
	$('#'+timeid).live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#'+timeid).live("blur",function(){
		this.value=CheckEmPcsTime(this.id,dateid);
	})
	$('#'+timeid).live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	
} 
/// ��ȡ�����ʱ��������
function SetEmPcsTime(id){
	
	var InTime = $("input[id^='"+id+"']").val();
	if (InTime == ""){return "";}
	InTime = InTime.replace(":","");
	return InTime;
}
///  Ч��ʱ����¼�����ݺϷ���
function CheckEmPcsTime(timeid,dateid){
	$("body").css("height",screen.availHeight); //hxy 2020-03-21 chrome
	var InTime = $("input[id^='"+timeid+"']").val();
	if (InTime == ""){return "";}
	if (InTime.length < 4){InTime = "0" + InTime;}
	if((InTime.length == 5)&&(InTime.indexOf(":")>0)&&(InTime.substring(0,2)<24)&&(InTime.substring(3,5)<60)){
		return InTime;
	}
	if ((InTime.length != 4)){
		$.messager.alert("��ʾ:","��¼����ȷ��ʱ���ʽ��<span style='color:red;'>����:18:23,��¼��1823</span>");
		$('#'+ id).val("");
		return "";
	}
	
	var hour = InTime.substring(0,2);
	if (hour > 23){
		$.messager.alert("��ʾ:","Сʱ�����ܴ���23��");
		$('#'+ id).val("");
		return "";
	}
	
	var itme = InTime.substring(2,4);
	if (itme > 59){
		$.messager.alert("��ʾ:","���������ܴ���59��");
		$('#'+ id).val("");
		return "";
	}
	//sufan  2019-11-12  ѡ������ʱ�ж��·���ʱ��
	
	if(($("#"+dateid).length==0)||(dateid==undefined)){
		var RelDate="";
	}else{
		var RelDate=$("input[id^='"+dateid+"']").datebox('getValue');
	}
	var Reltiem=hour +":"+ itme;  
	var DateFlag="";
	runClassMethod("web.DHCADVCOMMON","DateTimeCompare",{'Date':RelDate,'Time':Reltiem},
		function(data){
			DateFlag=data;
	},"text",false);
	if(DateFlag==1){
		$.messager.alert("��ʾ:","��дʱ����ڵ�ǰʱ�䣡");
		$("#"+timeid).val("");
		return "";
	}else{
		
		return hour +":"+ itme;
	}
				
	
	/* //sufan 2109-11-12 ���ӹ�������ʱ���ж�
	if((dateid!="")&&(dateid!=undefined)&&($("input[id^='"+dateid+"']").length>0)){  
		var RelDate=$("input[id^='"+dateid+"']").datebox('getValue');
		if (new Date(RelDate).toDateString() === new Date().toDateString()) {	
			var seletime=(hour+""+itme).valueOf();
			var nowhour=new Date().getHours();
			if(nowhour<10){
				nowhour="0"+nowhour;
			}
			var nowitme=new Date().getMinutes();
			if(nowitme<10){
				nowitme="0"+nowitme;
			}
			var currtime=(nowhour+""+nowitme).valueOf();
			if(seletime>currtime){
				$.messager.alert("��ʾ:","��дʱ����ڵ�ǰʱ�䣡");
				$('#'+ timeid).val("");
				return "";
			}else{
				return hour +":"+ itme;
			}
		}else{
			return hour +":"+ itme;
		}
	}else{
		
		return hour +":"+ itme;
	} */
	//return hour +":"+ itme;
}


//��������input������  id:Ԫ��id , type:0����,1 ������ , min:��ֵ��Χ��Сֵ ,max: ��ֵ��Χ���ֵ
function chknum(id,type,min,max){
	var type=(((type+"")=="")||(type==undefined))?0:type;
	var min=(((min+"")=="")||(min==undefined))?-1:parseInt(min);
	var max=(((max+"")=="")||(max==undefined))?-1:parseInt(max);	
	if(type==0){
		$("input[id^='"+id+"']").live("keyup",function(){
			this.value=this.value.replace(/\D/g,'');
			if(this.value.indexOf(".")< 0 && this.value !=""){//�����Ѿ����ˣ��˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
		    	this.value= parseInt(this.value); 
		    } 
		    if(((max!=-1)&&(min!=-1) )&&((this.value<min)||(this.value>max))&&(this.value!=""))
		    {
				$.messager.alert("��ʾ:","������"+min+"-"+max+"������");	
				this.value="";
			}else if((min!=-1)&&(this.value<min)&&(max==-1)&&(this.value!="")){
				$.messager.alert("��ʾ:","�����벻С��"+min+"������");	
				this.value="";
			}else if((max!=-1)&&(this.value>max)&&(min==-1)&&(this.value!="")){
				$.messager.alert("��ʾ:","�����벻����"+max+"������");	
				this.value="";
			}
		})
	}
	if(type==1){
		$("input[id^='"+id+"']").live("keyup",function(){
			//�Ȱѷ����ֵĶ��滻�����������ֺ�.
			this.value = this.value.replace(/[^\d.]/g,"");
			//���뱣֤��һ��Ϊ���ֶ�����.
			this.value = this.value.replace(/^\./g,"");
			//��ֻ֤�г���һ��.��û�ж��.
			this.value = this.value.replace(/\.{2,}/g,".");
			//��֤.ֻ����һ�Σ������ܳ�����������
			this.value = this.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
			//this.value = this.value.replace(/^(\-)*(\d+)\.(\d\d).*$/, '$1$2.$3'); //ֻ����������С�� (\d\d\d) С�������λ (\d) С�����һλ
			if(this.value.indexOf(".")< 0 && this.value !=""){//�����Ѿ����ˣ��˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
		    	this.value= parseFloat(this.value); 
		    } 
		    if(((max!=-1)&&(min!=-1) )&&((this.value<min)||(this.value>max))&&(this.value!=""))
		    {
				$.messager.alert("��ʾ:","������"+min+"-"+max+"����");	
				this.value="";
			}else if((min!=-1)&&(this.value<min)&&(max==-1)&&(this.value!="")){
				$.messager.alert("��ʾ:","�����벻С��"+min+"����");	
				this.value="";
			}else if((max!=-1)&&(this.value>max)&&(min==-1)&&(this.value!="")){
				$.messager.alert("��ʾ:","�����벻����"+max+"����");	
				this.value="";
			}
		})
	}
} 

/// ����������Ŵ���
function $_TrsSymbolToTxt(tmpString){
	
	var WELL_SYMBOL = "TSS01";   /// #
	var ARROW_SYMBOL = "TSS02";  /// ^
	var QUM_SYMBOL = "TSS03";  /// "
	var COMMA_SYMBOL = "TSS04";  /// ,
	if (tmpString.indexOf("#") != "-1"){
		tmpString = tmpString.replace(/\#/g,WELL_SYMBOL);
	}
	if (tmpString.indexOf("^") != "-1"){
		tmpString = tmpString.replace(/\^/g,ARROW_SYMBOL);
	}
	if (tmpString.indexOf('"') != "-1"){
		tmpString = tmpString.replace(/\"/g,QUM_SYMBOL);
	}
	if (tmpString.indexOf(',') != "-1"){
		tmpString = tmpString.replace(/\,/g,COMMA_SYMBOL);
	}
	return tmpString;
}

/// ����������Ŵ���
function $_TrsTxtToSymbol(tmpString){
	
	if (tmpString.indexOf("TSS01") != "-1"){
		tmpString = tmpString.replace(/\TSS01/g,"#");
	}
	if (tmpString.indexOf("TSS02") != "-1"){
		tmpString = tmpString.replace(/\TSS02/g,"^");
	}
	if (tmpString.indexOf("TSS03") != "-1"){
		tmpString = tmpString.replace(/\TSS03/g,'"');
	}
	if (tmpString.indexOf("TSS04") != "-1"){
		tmpString = tmpString.replace(/\TSS04/g,',');
	}
	return tmpString;
}
// У��Ѫѹ
function checkBP(id){
	$("input[id^='"+id+"']").live("keyup",function(){
			//�Ȱѷ����ֵĶ��滻�����������ֺ�/
			this.value = this.value.replace(/[^\d\/]/g,"");
			//���뱣֤��һ��Ϊ���ֶ�����0
			this.value = this.value.replace(/^[0]/g,"");
			//���뱣֤��һ��Ϊ���ֶ�����/
			this.value = this.value.replace(/^\//g,"");
			//��ֻ֤�г���һ��.��û�ж��/
			this.value = this.value.replace(/\/{2,}/g,"/");
			//��֤.ֻ����һ�Σ������ܳ�����������
			this.value = this.value.replace("/","$#$").replace(/\//g,"").replace("$#$","/");
		
	})
	$("input[id^='"+id+"']").live("blur",function(){
			var text=this.value;
			var text1=text.split("/")[0];
			var text2=text.split("/")[1];
			if((text.indexOf("/")<0)||(text1=="")||(text2=="")){
				$.messager.alert("��ʾ:","��¼����ȷ��Ѫѹ��ʽ,����80/120");	
				this.value="";
			}
	})
}

//��������ѡ�񲻵ó������� //hxy 2020-03-18
function chkTableDate(id){
	$("input[id^='"+id+"'][class*='datebox-f']").each(function(){
		var datevalue=$("input[id^='"+this.id+"']").datebox("getValue");
			$("input[id^='"+this.id+"']").datebox({editable:false});
	    $(this).datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		$("input[id^='"+this.id+"']").datebox("setValue",datevalue);
	});
}

//����ѡ��ʱ����໥�Ƚ� 2017-03-06
function compareSelTowTime(BefDate,AftDate)
{
	var BefSelDateArr="",BefSelYear="",BefSelMonth="",BefSelDate="",AftSelDateArr="",AftSelYear="",AftSelMonth="",AftSelDate="";
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		BefSelDateArr=BefDate.split("/");
		BefSelYear=BefSelDateArr[2];
		BefSelMonth=(BefSelDateArr[1]);
		BefSelDate=(BefSelDateArr[0]);

		AftSelDateArr=AftDate.split("/");
		AftSelYear=AftSelDateArr[2];
		AftSelMonth=(AftSelDateArr[1]);
		AftSelDate=(AftSelDateArr[0]);

	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		BefSelDateArr=BefDate.split("-");
		BefSelYear=BefSelDateArr[0];
		BefSelMonth=(BefSelDateArr[1]);
		BefSelDate=(BefSelDateArr[2]);
		
		AftSelDateArr=AftDate.split("-");
		AftSelYear=AftSelDateArr[0];
		AftSelMonth=(AftSelDateArr[1]);
		AftSelDate=(AftSelDateArr[2]);
	
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		BefSelDateArr=BefDate.split("/");
		BefSelYear=BefSelDateArr[2];
		BefSelMonth=(BefSelDateArr[0]);
		BefSelDate=(BefSelDateArr[1]);
		
		AftSelDateArr=AftDate.split("/");
		AftSelYear=AftSelDateArr[2];
		AftSelMonth=(AftSelDateArr[0]);
		AftSelDate=(AftSelDateArr[1]);
	
	}
	
	if(BefSelYear>AftSelYear){
		return false;
	}
	if((BefSelYear==AftSelYear)&(BefSelMonth>AftSelMonth)){
		return false;
	}
	if((BefSelYear==AftSelYear)&(BefSelMonth==AftSelMonth)&(BefSelDate>AftSelDate)){
		return false;
	}
	
	return true;
}

//����δ����ı���
function $getValue(value){
	return value==undefined?"":value;
}
