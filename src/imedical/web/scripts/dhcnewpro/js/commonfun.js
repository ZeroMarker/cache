
/// 获取参数  bianshuai 2014-09-18
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    var search=this.location.search;
	if(this.parent.location){//2023-03-17 st HOS组件菜单方式取值不到hosNoPatOpenUrl入参
		var HosMenuSearch=this.parent.location.search; 
		if((search.indexOf(paramName)<0)&&(HosMenuSearch.indexOf(paramName)>0)){ 
		    search=HosMenuSearch;
		}
	}//ed

    if (search.indexOf("?") == 0 && search.indexOf("=")>1){
        arrSource = unescape(search).substring(1,search.length).split("&");
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

/// 格式化日期  bianshuai 2014-09-18
function formatDate(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+Day+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+Day;
		}
	}
}

/// 格式化日期  yangyongtao 2017-11-17
function formatDateD(t){
	
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	//var Day = curr_Date.getDate();
	//return Year+"-"+Month+"-"+Day;
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+"01";
	}else{
		if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return "01"+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+"01";
		}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
			return Month+"/"+"01"+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+"01";
		}
	}
}

/*
LiangQiang 2014-08-08
定制弹出Div窗体,默认是窗品项目列表
*/
var CreatMyDiv=function (input,tarobj,mydivid,mydivw,mydivh,mytblid,mycols,mydgs,mydgid,mydesc,fn)
{
	this.input=input;　//入参
	this.tarobj=tarobj; //目标源
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
		/* if((input.length)==0){
		   //return;
		} */
      
		RemoveMyDiv();
		$(document.body).append('<div id='+mydivid+' style="width:'+mydivw+';height:'+mydivh+';border:1px solid #E6F1FA;position:absolute"></div>') 
		$("#"+mydivid).append('<div id='+mytblid+'></div>');

		var mydiv=$("#"+mydivid);

		mydiv.show();			  
		mydiv.css("left",tarobj.offset().left);
		if(mydivh<tarobj.offset().top){
		   mydiv.css("top",tarobj.offset().top-mydivh); //div位置 向上弹出
		}else
		{
		   mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());  //div位置
		}
	  
		if (mycols=='')
		{
			mycols = [[
				{field:'InciCode',title:'代码',width:60}, 
				{field:'InciDesc',title:'名称',width:220}, 
				{field:'Spec',title:'规格',width:80},
				{field:'ManfName',title:'厂家',width:80},
			]];
		}

		if (mydgs=='')
		{
			mydgs = {
				url:'dhcst.drugutil.csp'+'?actiontype=GetDrugsForJquery&Input='+input ,
				columns: mycols,  //列信息
				pagesize:10,  //一页显示记录数
				table: '#drugsgrid', //grid ID
				field:'InciCode', //记录唯一标识
				params:null,  // 请求字段,空为null
				tbar:null, //上工具栏,空为null
				NullMsgs:""
			}
		}

		var gridobj = new DataGrid(mydgs);
		gridobj.init();


		//设置分页控件  

		var p = $("#"+mytblid).datagrid('getPager');  

		$(p).pagination({  

			buttons: [{
				text:'关闭',
				handler:function(){
					RemoveMyDiv();
					fn('');
				}
			}]
		});

		var mygrid=$("#"+mytblid);
		mygrid.datagrid('getPanel').panel('panel').attr("tabindex",0);
		mygrid.datagrid('getPanel').panel('panel').focus() ;
		/*mygrid.datagrid('getPanel').panel('panel').blur(function(){
    		setTimeout(function() {
    		$("#"+mydivid).hide();
    		},200);
		}); */ //qunianpeng 2018/1/17 注释
	
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
				if (event && event.preventDefault){	//关闭默认行为 qunianpeng 2018/1/17
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
		    	if (event && event.preventDefault){ 	//qunianpeng 2018/1/17
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

		//清空
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

/*
  creator:LiangQiang
  creatdate:2014-08-01
  description:jquery easyui　相关控件封装

*/

/*
   datagrid控件
*/
var DataGrid=function (obj)
{
	this.url=obj.url;
	this.columns=obj.columns;
	this.pagesize=obj.pagesize;
	this.table=obj.table;
	this.field=obj.field;
	this.params=obj.params;
	this.toolbar=obj.tbar;
	this.NullMsg=obj.NullMsgs ;// yuliping 返回空json的错误信息
}
DataGrid.prototype={ 
	init:function(){
		//初始化
		var tmptbl=this.table;
		var msg=this.NullMsg  ;// yuliping 返回空json的错误信息
		$(this.table).datagrid({  
			bordr:false,
			fit:true,
			singleSelect:true,
			loadMsg:null,
			idField:this.field, 
			striped: true, 
			pagination:true,
			rownumbers:true,//行号 
			pageSize:this.pageSize,
			pageList:[this.pagesize,this.pagesize*2],
			columns:this.columns,
			url:this.url,
			queryParams:this.params,
			toolbar:this.toolbar,
			onLoadSuccess:function() {
				var rows = $(tmptbl).datagrid('getRows');
				var rowcount=rows.length ;			   
				if (rowcount==0) 
				{
					if(msg!=""){
						//$.messager.alert("Warning",msg) ;//2018-07-13 cy
						$.messager.alert("Warning","数据不存在，请核实！") ;//2018-07-13 cy
					}
					
					return;
				}
				$(tmptbl).datagrid('selectRow', 0);
			}

		});
    },
	loaddata:function(params){
		//按条件加载数据
		$(this.table).datagrid('options').url=this.url;
        $(this.table).datagrid('options').queryParams=params;
		$(this.table).datagrid('reload');
	},
	clickrow:function(fn){
		//单击行
		$(this.table).datagrid('options').onClickRow=function(rowIndex, rowData){
			fn(rowIndex, rowData)
		}
	},
	dblclickrow:function(fn){
		//双击行
		$(this.table).datagrid('options').onDblClickRow=function(rowIndex, rowData){
			fn(rowIndex, rowData)
		}
	},
    clear:function(){
		//清空数据
		$(this.table).datagrid('options').url=null;
		$(this.table).datagrid('loadData',{total:0,rows:[]}); 
	}
}


/// 格式化日期  bianshuai 2014-09-18
function formatDate4(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(Month<10) Month="0"+Month;
	if(Day<10) Day="0"+Day;
	return Day+"/"+Month+"/"+Year;
}

/// 格式化日期  bianshuai 2014-09-18
function formatDate1(t){
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(Month<10) Month="0"+Month;
	if(Day<10) Day="0"+Day;
	return Month+"/"+Day+"/"+Year;
}

///获取上一年时间
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

//弹出路径选择框 2017-12-22 冬至添加
function browseFolder()
{  
  try {  
	  var Message = "请选择路径"; //选择框提示信息  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//起始目录为：我的电脑  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // 返回 FolderItems 对象  
		  Folder = Folder.item();  // 返回 Folderitem 对象  
		  Folder = Folder.Path;    // 返回路径  
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

/// 拆分字符串
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];   /// 初始化空数组
	var Len = 0; j = 0; k = 0;
	/// bianshuai  截取药名
	for (var i=0; i<TmpString.length; i++) {
		var vChar = TmpString.charCodeAt(i);   
		//单字节加1    
		if ((vChar >= 0x0001 && vChar <= 0x007e)||(0xff60 <= vChar && vChar <= 0xff9f)){   
			Len++;   
		}else{   
			Len+=2;   
		}
		
		if(((Len%LimitLen == 0)||(Len%LimitLen == 1))&(Len != 1)){
			
			if ((i - k) < 2) continue;
			TmpLabelArr[j] = TmpString.substr(k, i-k);  /// 截取字符串
			if (j == 4){
				TmpLabelArr[j] = TmpLabelArr[j] + "...";   /// 最后一个字符串后面加...
				break;
			}
			j = j + 1;
			k = i;
		}
		if ((i == TmpString.length - 1)&(k != i)){
			TmpLabelArr[j] = TmpString.substr(k, (i-k)+1);
		}
	}
	if (TmpLabelArr.join("") == ""){
		TmpLabelArr[0] = TmpString;
	}
	return TmpLabelArr;
}

/**去掉字符串前后所有空格*/
function trim(str){
	var res="";
	if ((typeof str != "undefined")&(str != "")){
		res = str.replace(/(^\s*)|(\s*$)/g, "");
	}
	return res;
} 
/**
*@author : qunianpeng 
*@date : 2018-8-30
*@param : {String} str 超过一行长的字符串
*@param : {int} lineWordNum  一行显示多少个字数
*@other label不能自动换行,要加\n能换行
*改造汪会财的方法，在换行前增加空字符，避免换行后超出左侧限制
*str = autoWordEnter(str,46);
*/function autoWordEnterNew(str, lineWordNum){
	var tmp, rtn="";
	for(var i =0;i<str.length; i++){
		tmp = str.substr(i,lineWordNum);
		i += lineWordNum-1;
		rtn += " "+tmp+"\n  "; 	/// 在换行前增加空字符，避免换行后超出左侧限制
	}
	return rtn
}

/// 病人基本内容特殊符号处理
function $_TrsSymbolToTxt(tmpString){
	
	var WELL_SYMBOL = "TSS01";   /// #
	var ARROW_SYMBOL = "TSS02";  /// ^
	if (tmpString.indexOf("^") != "-1"){
		tmpString = tmpString.replace(/\^/g,ARROW_SYMBOL);
	}
	return tmpString;
}

/// 病人基本内容特殊符号处理
function $_TrsTxtToSymbol(tmpString){
	
	if (tmpString.indexOf("TSS02") != "-1"){
		tmpString = tmpString.replace(/\TSS02/g,"^");
	}
	return tmpString;
}

/// datagrid动态设置列标题的的扩展方法
$.extend($.fn.datagrid.methods, {   
    setColumnTitle: function(jq, option){   
        if(option.field){  
            return jq.each(function(){   
                var $panel = $(this).datagrid("getPanel");  
                var $field = $('td[field='+option.field+']',$panel);  
                if($field.length){  
                    var $span = $("span",$field).eq(0);  
                    $span.html(option.text);  
                }  
            });  
        }  
        return jq;       
    }   
}); 

///是否IE浏览器啊
function isIE() {
	if (!!window.ActiveXObject || "ActiveXObject" in window){
		return true;
	}else{
		return false;
	}
}

/**
* 公共弹出界面
* @author zhouxin
*/
function commonShowWin(option){
		var url = tokenUrl(option.url);
		var content = '<iframe src="'+url+'" scrolling="auto" width="100%" height="100%" frameborder="0" scrolling="no" style="display:block;"></iframe>';
		var defOpt={
			iconCls:"icon-w-paper",
			width: 1300,
			height: 600,
			closed: false,
			content: content,
			modal: true,
			isTopZindex:true
			
		}
		$.extend(defOpt,option);
		if (document.getElementById("CommonWin")){
			winObj = $("#CommonWin");
		}else{
			winObj = $('<div id="CommonWin"></div>').appendTo("body");	
		}
		$('#CommonWin').dialog(defOpt);
}

function commonCloseWin(){
	$('#CommonWin').dialog('close');
}

function commonParentCloseWin(){
	window.parent.$('#CommonWin').dialog('close');
}

function formatHtmlToValue(text){
	text=text||'';
	text = text.replace(new RegExp('&nbsp;',"g"),' '); //text.replaceAll("&nbsp;"," ");
	text = text.replace(new RegExp('&nbsp',"g"),' '); //text.replaceAll("&nbsp"," ");
	return text;
}

///是否开启了多屏幕
function isOpenMoreScreen(){
	if(top.MWScreens){
		if(top.MWScreens.screens){
			return top.MWScreens.screens.length>1?true:false;
		}
	}
	
	if(top.opener){
		if(top.opener.MWScreens){
			return top.opener.MWScreens.screens.length>1?true:false;
		}
	}
	
	return false;
}

///url拼接token
function tokenUrl(url){
	if(typeof websys_getMWToken === "function"){
		url = url+(url.indexOf('?')!=-1?'&':'?')+"&MWToken="+websys_getMWToken();
	}
	return url;
}

///hos关闭window
function hosCloseWindow(winId){
	window.top.postMessage({ 
		operatePortalWindow: {
			windowId: winId,
			operate: 'windowClose'
		}
	},"*");
}

///hos创建window
function hosCreateWindow(title,url){
	
	url+=((url.indexOf('?')>0?'&':'?')+'windowId='+uuid())
    window.top.postMessage( {embedWindow: {name:title,link:url}}, "*");	
}

///uuid
function uuid() {
	return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0,
            v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

/// hos对于没有就诊的情况下打开患者列表
function hosOpenPatList(url){
	var e=getParam('EpisodeID')
	if(e) return;
	
	if (typeof LocAdmType === 'undefined') LocAdmType='E';

	if(LocAdmType=='E'){
		var o=url+'?hosOpen=1';
		o=tokenUrl(o);
		window.open(o,'_blank','height='+(window.screen.availHeight-200)+', width='+(window.screen.availWidth-200)+', top=100, left=100,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
	}else{
		showPatientList(LocAdmType);
	}
	return;
}


/// 替换某个url中的参数值
function changeURLArg(url,arg,arg_val){ 
    var pattern=arg+'=([^&]*)'; 
    var replaceText=arg+'='+arg_val; 
    if(url.match(pattern)){ 
        var tmp='/('+ arg+'=)([^&]*)/gi'; 
        tmp=url.replace(eval(tmp),replaceText); 
        return tmp; 
    }else{ 
        if(url.match('[\?]')){ 
            return url+'&'+replaceText; 
        }else{ 
            return url+'?'+replaceText; 
        } 
    } 
    return url+'\n'+arg+'\n'+arg_val; 
}

///对象的形式改变参数
function changeURLArgs(url,argObj){
	if(!url) return;
	
	for(var key in argObj){
		url = changeURLArg(url,key,argObj[key]);
	}
	
	return url;
}

///设置hos公共区域的患者信息
function hosSetPatient(data){
	var obj = {
		type: 'postFromProd',
		messageList: 
		[
		    {
		        key: 'EpisodeID',
		        value: data.EpisodeID
		    },{
		        key: 'PatientID',
		        value: data.PatientID
		    }
		]
	}

	var _w = data.hosOpen?window.opener.top:window.top;
	_w.postMessage(obj, "*")
    
    if(data.hosOpen){
	    if(window.opener){
		   var nowUrl = window.opener.location.href;
		   window.opener.location.href = changeURLArgs(nowUrl,{EpisodeID:data.EpisodeID,PatientID:data.PatientID});
		}
		window.close();
	}
}

///是否开启了多屏幕
function isOpenMoreScreen(){
	
	
	//搞啥玩意儿判断,直接写死,
	
	return true;
	
	
	var ret=false;
	if(top.MWScreens){
		if(top.MWScreens.screens){
			
			if(top.MWScreens.screens.length>1) ret=true;
			
			if(!ret){
				//判断当只有一个屏幕的是否是宽屏幕
				console.log(top.MWScreens.screens[0]);
			}
		}
	}
	if(ret) return ret;
	
	
	if(top.opener){
		if(top.opener.MWScreens){
			if(top.opener.MWScreens.screens.length>1) ret=true;
			console.log(top.opener.MWScreens.screens[0]);
		}
	}
	
	
	
	return ret;
}

function showPatientList(locType)
{
	var src="opdoc.patient.list.csp?NotShowBtnBar=Y";
	if(locType=='I'){
		src="inpatientlist.csp";
	}

	if(typeof tokenUrl=='function') src=tokenUrl(src);
	var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	ShowHISUIWindow("患者切换", src,"icon-change-loc",1800, 600);
}
function switchPatient(PatientID,EpisodeID,mradm)
{
	CloseHISUIWindow();
	hosSetPatient({EpisodeID:EpisodeID,PatientID:PatientID});
	var nowUrl = window.location.href;
	var newUrl = changeURLArgs(nowUrl,{EpisodeID:EpisodeID,PatientID:PatientID});
	window.location.replace(newUrl);
	
}

//hisui弹窗 支持对象类型传参(参数按hisui window)，推荐使用基础平台的websys_showModal
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#_HUI_Model_Win').size()){
        $("body").append("<div id='_HUI_Model_Win' class='hisui-window' style='overflow:hidden;'></div>");
    }
    if((arguments.length==1)&&(typeof arguments[0]=='object')){
        if(typeof tokenUrl=='function') arguments[0].src=tokenUrl(arguments[0].src);
        var opts=$.extend({
            width:width,
            height:height,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+arguments[0].src+"'></iframe>"
        },arguments[0]);
    }else{
        if(typeof tokenUrl=='function') src=tokenUrl(src);
        var opts={
            iconCls:iconCls,
            width:width,
            height:height,
            title:title,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
        };
    }
    return $('#_HUI_Model_Win').window(opts).window('center');
}

function CloseHISUIWindow()
{
    if($('#_HUI_Model_Win').size()){
        $('#_HUI_Model_Win').window('close');
    }
}