
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
	//return Year+"-"+Month+"-"+Day;
	
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

/// ��ʽ������  yangyongtao 2017-11-17
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
		if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY 2017-03-07 cy
			return "01"+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
			return Year+"-"+Month+"-"+"01";
		}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
			return Month+"/"+"01"+"/"+Year;
		}else{ //2017-03-15 cy
			return Year+"-"+Month+"-"+"01";
		}
	}
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
		   mydiv.css("top",tarobj.offset().top-mydivh); //divλ�� ���ϵ���
		}else
		{
		   mydiv.css("top",tarobj.offset().top+ tarobj.outerHeight());  //divλ��
		}
	  
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
				columns: mycols,  //����Ϣ
				pagesize:10,  //һҳ��ʾ��¼��
				table: '#drugsgrid', //grid ID
				field:'InciCode', //��¼Ψһ��ʶ
				params:null,  // �����ֶ�,��Ϊnull
				tbar:null, //�Ϲ�����,��Ϊnull
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
		/*mygrid.datagrid('getPanel').panel('panel').blur(function(){
    		setTimeout(function() {
    		$("#"+mydivid).hide();
    		},200);
		}); */ //qunianpeng 2018/1/17 ע��
	
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
				if (event && event.preventDefault){	//�ر�Ĭ����Ϊ qunianpeng 2018/1/17
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

/*
  creator:LiangQiang
  creatdate:2014-08-01
  description:jquery easyui����ؿؼ���װ

*/

/*
   datagrid�ؼ�
*/
var DataGrid=function (obj)
{
	this.url=(typeof websys_writeMWToken=='function')?websys_writeMWToken(obj.url):obj.url;
	this.columns=obj.columns;
	this.pagesize=obj.pagesize;
	this.table=obj.table;
	this.field=obj.field;
	this.params=obj.params;
	this.toolbar=obj.tbar;
	this.NullMsg=obj.NullMsgs ;// yuliping ���ؿ�json�Ĵ�����Ϣ
}
DataGrid.prototype={ 
	init:function(){
		//��ʼ��
		var tmptbl=this.table;
		var msg=this.NullMsg  ;// yuliping ���ؿ�json�Ĵ�����Ϣ
		$(this.table).datagrid({  
			bordr:false,
			fit:true,
			singleSelect:true,
			loadMsg:null,
			idField:this.field, 
			striped: true, 
			pagination:true,
			rownumbers:true,//�к� 
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
						$.messager.alert("Warning","���ݲ����ڣ����ʵ��") ;//2018-07-13 cy
					}
					
					return;
				}
				$(tmptbl).datagrid('selectRow', 0);
			}

		});
    },
	loaddata:function(params){
		//��������������
		$(this.table).datagrid('options').url=this.url;
        $(this.table).datagrid('options').queryParams=params;
		$(this.table).datagrid('reload');
	},
	clickrow:function(fn){
		//������
		$(this.table).datagrid('options').onClickRow=function(rowIndex, rowData){
			fn(rowIndex, rowData)
		}
	},
	dblclickrow:function(fn){
		//˫����
		$(this.table).datagrid('options').onDblClickRow=function(rowIndex, rowData){
			fn(rowIndex, rowData)
		}
	},
    clear:function(){
		//�������
		$(this.table).datagrid('options').url=null;
		$(this.table).datagrid('loadData',{total:0,rows:[]}); 
	}
}


/// ��ʽ������  bianshuai 2014-09-18
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

/// ��ʽ������  bianshuai 2014-09-18
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

/// ����ַ���
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];   /// ��ʼ��������
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
	if (TmpLabelArr.join("") == ""){
		TmpLabelArr[0] = TmpString;
	}
	return TmpLabelArr;
}

/**ȥ���ַ���ǰ�����пո�*/
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
} 
/**
*@author : qunianpeng 
*@date : 2018-8-30
*@param : {String} str ����һ�г����ַ���
*@param : {int} lineWordNum  һ����ʾ���ٸ�����
*@other label�����Զ�����,Ҫ��\n�ܻ���
*��������Ƶķ������ڻ���ǰ���ӿ��ַ������⻻�к󳬳��������
*str = autoWordEnter(str,46);
*/function autoWordEnterNew(str, lineWordNum){
	var tmp, rtn="";
	for(var i =0;i<str.length; i++){
		tmp = str.substr(i,lineWordNum);
		i += lineWordNum-1;
		rtn += " "+tmp+"\n  "; 	/// �ڻ���ǰ���ӿ��ַ������⻻�к󳬳��������
	}
	return rtn
}

/// ���˻�������������Ŵ���
function $_TrsSymbolToTxt(tmpString){
	
	var WELL_SYMBOL = "TSS01";   /// #
	var ARROW_SYMBOL = "TSS02";  /// ^
	if (tmpString.indexOf("^") != "-1"){
		tmpString = tmpString.replace(/\^/g,ARROW_SYMBOL);
	}
	return tmpString;
}

/// ���˻�������������Ŵ���
function $_TrsTxtToSymbol(tmpString){
	
	if (tmpString.indexOf("TSS02") != "-1"){
		tmpString = tmpString.replace(/\TSS02/g,"^");
	}
	return tmpString;
}

/// datagrid��̬�����б���ĵ���չ����
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