function GetRequest() {

   var url = location.search; //��ȡurl��"?"������ִ�
   

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
function getParam(paramName)
{
    paramValue = "";
    isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1)
    {
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        i = 0;
        while (i < arrSource.length && !isFound)
        {
            if (arrSource[i].indexOf("=") > 0)
            {
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase())
                 {
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        }   
    }
   return paramValue;
}

/* /// ��ʽ������  bianshuai 2014-09-18
function formatDate(t)
{
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
} */

/// ��ʽ������  bianshuai 2014-09-18
///qunianpeng �޸�  �����������
function formatDate(t)
{	

	var curr_time = new Date();  
	var Year = curr_time.getFullYear();
	var Month = curr_time.getMonth()+1;
	var Day = curr_time.getDate()+parseInt(t);
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

/// ��ʽ����ǰʱ��
function formatCurrTime()
{
	var curr_Date = new Date();
	var Hours = curr_Date.getHours();  
    var Minutes = curr_Date.getMinutes(); 
    return Hours+":"+Minutes;
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
	this.input=input;��//���
	this.tarobj=tarobj; //Ŀ��Դ
	this.mydivid=mydivid; //
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
		   return;
	   }

       RemoveMyDiv();

       $(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
	   $("#"+mydivid).append('<div id='+mytblid+'></div>');

       var mydiv=$("#"+mydivid);			 
	   mydiv.show();			  
	   mydiv.css("left",tarobj.offset().left);
	   mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());

	   if (mycols=='')
	   {
		   mycols = [[
				{field:'InciCode',title:'����',width:60}, 
				{field:'InciDesc',title:'����',width:220}, 
				{field:'Spec',title:'���',width:80},
				{field:'ManfName',title:'����',width:80},
		   ]];
	  }

	  if ((mydgs=='')||(mydgs==undefined))
	  {
			mydgs = {
				url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
				columns: mycols,  //����Ϣ
				pagesize:10,  //һҳ��ʾ��¼��
				table: '#drugsgrid', //grid ID
				field:'InciCode', //��¼Ψһ��ʶ
				params:null,  // �����ֶ�,��Ϊnull
				tbar:null //�Ϲ�����,��Ϊnull
			}
	  }
      var gridobj = new DataGrid(mydgs);
      gridobj.init();

      var mygrid=$("#"+mytblid);
      mygrid.datagrid('getPanel').panel('panel').focus() ;
	
	  mygrid.gridupdown(mygrid);
	  mygrid.datagrid('getPanel').panel('panel').bind('keydown', function (e) {
		
        switch (e.keyCode) {
        case 13: // enter
		   var InciDesc=mygrid.datagrid('getSelected').InciDesc ;
		   rowIndex=mygrid.datagrid('getRowIndex',mygrid.datagrid('getSelected'))
		   RemoveMyDiv();
		   fn(InciDesc,PhcdfDr);
		   return ;
		   
        case 27:  //Esc
		   RemoveMyDiv();
		   fn('');
		   return;

		}
	  })
	  mygrid.datagrid('getPanel').panel('panel').blur(function() { 

		 if (rowIndex=="")
		 {
			 //alert(1)
			//RemoveMyDiv();
			//fn('');

		 }   
	  });

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


//����·��ѡ���
function browseFolder()
{  
  try {  
	  var Message = "��ѡ��·��"; //ѡ�����ʾ��Ϣ  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//��ʼĿ¼Ϊ���ҵĵ���  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // ���� FolderItems ����  
		  Folder = Folder.item();  // ���� Folderitem ����  
		  Folder = Folder.Path;    // ����·��  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }  
  catch(e) 
  {  
	  alert(e.message);  
  }  
}


function GetGridOpt(grid)
{
	var opt=$(grid).datagrid('options');
	return opt
}
//�ж��ֶ�������λ��,yunhaibao20160701
 Array.prototype.indexOf = function(el){
	 for (var i=0,n=this.length; i<n; i++){
	 	if (this[i] === el){
	    	return i;
	  	}
	 }
	 return -1;
}


var LINK_CSP="dhcapp.broker.csp";
//��ǰ����
var editIndex = undefined;
/**
 * �����к�̨����
 * @zhouxin
 * @param className ������
 * @param methodName ������
 * @param datas ����{}
 * @param �ص�����
 * runClassMethod("web.DHCAPPPart","find",{'Id':row.ID,'Name':row.Name},function(data){ alert() },"json")	
 */
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){

	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
