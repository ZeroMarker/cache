/*������Ȩ*/
var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// ֪ʶ�������
var extraAttr = "KnowType";			// ֪ʶ����(��������)
var extraAttrValue = "ModelFlag" 	// ʵ����(��������ֵ)
var selectEle="";

function initPageDefault(){
	
	//InitPageComponent();	/// ��ʼ������ؼ�
	InitPageDataGrid();		/// ��ʼ������Datagrid
	InitButton();			/// ��ʼ��������水ť��Ӧ
	new Paging('pageSea', {
        nowPage: 1,                 // ��ǰҳ
        pageNum: 2,                // ��ҳ��
        buttonNum: 5,               // Ҫչʾ��ҳ������
        canJump: 0,                 // �Ƿ���ʾ��ת������ת  0(Ĭ��):����ʾ    1:��ʾ
        showOne: 0,                 // ֻ��һҳʱ���Ƿ���ʾ  0:����ʾ     1(Ĭ��):��ʾ
        callback: function (cpage) { //�ص�����
            alert(cpage);
        }
    })


	//$(".pagination").html("");
	//$(".pagination").pagination({layout:['first','prev','links','next','last']});
}
// ��ʼ������ؼ�
function InitPageComponent()
{
	/// ֪ʶ������
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //���ݼ�������¼�
	    	$("#libcombo").combobox('setValue',5)
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("libcombo",url,'',option).init();
}
// ��ʼ������DataGrid
function InitPageDataGrid(){

	/// ҽԺ
	///  ����columns
	var hospcolumns=[[
		{field:'desc',title:'ҽԺ',width:400}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	
	///  ����datagrid
	var hospoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: false,
	    onClickRow: function (rowIndex, rowData) {
		    // if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"D";
		   		selectEle = currLibDr +"^"+ "D" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///ְ��
	var ctpcolumns=[[  
		{field:'desc',title:'ְ��',width:400}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var ctpoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"C";
		   		selectEle = currLibDr +"^"+ "C" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryCtCptList";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///ҽ������
	var docloccolumns=[[  
		{field:'code',title:'����',width:200,hidden:true}, 
		{field:'desc',title:'����',width:400}, //qunianpeng 2017/10/9
		{field:'rowid',title:'rowid',hidden:true}
	]];	
	var doclocoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doclocbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"L";
		   		selectEle = currLibDr +"^"+ "L" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryDocLocList&Input=";
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();
	
	///ҽ��
	var doccolumns=[[  
		{field:'desc',title:'ҽ��',width:200},
		{field:'code',title:'����',width:200},  
		{field:'rowid',title:'rowid',hidden:true}
	]];
	var docoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		fit : false,
		pageSize : [30],
		pageList : [30,60,90],
		pagination: true,
		toolbar:'#doctorbar',
		onClickRow: function (rowIndex, rowData) {
		    //if (currLibDr !== ""){
				var pointer=rowData.rowid;
		   		var input=currLibDr+"^"+pointer+"^"+"U";
		   		selectEle = currLibDr +"^"+ "U" +"^"+ pointer;
		   		QueryAccitm(input);
			//}else{
				//$.messager.alert('������ʾ','֪ʶ�ⲻ��Ϊ��!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// Ȩ���б�
	var accitmclumns=[[ 
		{field:'desc',title:'����',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'֪ʶ��',width:80,hidden:true}, 
		{field:'ralation',title:'��ϵ',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'����',hidden:true},
		{field:'chk',title:'ѡ��',hidden:true},
		{field:'dataType',title:'�ֵ������',hidden:true}
	]];	
	var accoption = {
		fitColumn:true,
		rownumbers : false,
		singleSelect : true,
		//fit : false,
		toolbar:'#btntoolbar',
		pageSize : [500],
		pageList : [500,1000,1500,2000,2500,3000],
		pagination: false,
		pagePosition:'top',	
		onLoadSuccess: function (index,data) { //���ݼ�������¼�
           $.each(data.rows,function(tmpindex,obj){
	           if (obj._parentId == ""){
		       		return true;		// �˳�����ѭ��
		       }
		       if(obj.chk == "Y"){
			   		$HUI.treegrid("#accitmgrid").checkNode(obj.id);	
			   }
	       })
	      /* $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({
              });
            }
          });*/
        },
        uncheckNode:function(){
	        
	        
	    },
	    onLoadSuccess:function(node,data){
	      	
		   $(".tree-icon,.tree-file").removeClass("tree-icon tree-file");
    	   $(".tree-icon,.tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed");
	    }	
			   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryLibAccMenu";
	new ListTreeGrid('accitmgrid', accitmclumns, uniturl, accoption).Init();
}
/// ��ѯ��Ȩ��Ŀ
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		Input:input
	
	}); 
}
/// ��ʼ�����水ť��Ӧ
function InitButton(){

	// ���һس��¼�
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var Input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				Input:Input	
			});
		 }
	});
	
	// ҽ���س��¼�
	$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13") {			 
			 var input=$.trim($("#doctorno").val());  			
			$('#docgrid').datagrid('load',  {  
				input:input	
			});
		 }
�� });

	$("#btnSave").click(function(){
	   	SaveAcc();
    })
}

//������Ȩ
function SaveAcc()
{
	/*
	if (currPointer == ""){
		$.messager.alert("��ʾ","��ѡ��֪ʶ�����Ȩ����!","info");
		return ;
	}
	*/
	
	var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	/* if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ����Ŀ����б���!","info");
	    return;
	  
	} */
	var exitFlag = 0;
	if ((allCheck == "")||(allCheck == null)){
		$.messager.confirm('��ʾ', '����ѡ����Ŀ����ʱ�����������ǰ�û�����Ȩ����<br/>ȷ�������?', function(r){
			if (r){					
				SaveTemp();  				
			}
			else{
				return;
			}
		});	
	}else{
		SaveTemp();
	}		
    
 }

/// ����ǰ��֯��������
function SaveTemp(){
	
	var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	var tmpPar = "",ParArr=[],ParInfo ="",checkInfoArr = [];							
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){	// �ϲ�ڵ�			
			continue;
		}
		else{			
			var checkInfo = allCheck[i].id +":"+allCheck[i].dataType ;	// ��ѡ���ӽڵ�;
			var parRowID = allCheck[i]._parentId;	// ���ڵ�			
			if (ParArr.indexOf(parRowID)==-1){	// ���ڵ��Ѿ��洢��
				ParArr.push(parRowID);
				if (ParInfo == ""){
					ParInfo = parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;		
				}else{
					ParInfo = ParInfo +"!"+ parRowID+":DHC_CKBCommonDiction" +"^"+ checkInfo;	
				}
				checkInfoArr.push(allCheck[i].id);				
			}
			else{
				if (checkInfoArr.indexOf(allCheck[i].id)!=-1){
					continue;
				}			
				ParInfo = ParInfo +"^"+ checkInfo;	
				checkInfoArr.push(allCheck[i].id);				
			}			
		}
	}
	//		selectEle(֪ʶ������+"^"+������+"^"+������ֵ)   +"^"+ �����û� +"^"+ �ͻ���ip    +"@"+ ��Ŀid:�ֵ�����^��Ŀid:�ֵ�����!��Ŀid:�ֵ�����
 	input = selectEle +"^"+ LgUserID +"^"+ ClientIPAdd +"@"+ ParInfo; 
	
	Save(input); 

}
 
function Save(ListData){
					
	runClassMethod("web.DHCCKBGrantAuth","SaveAccItm",{"ListData":ListData},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("��ʾ","����ʧ��:"+jsonString,"error");
		}else{
			$.messager.alert("��ʾ","����ɹ�","info");
		}
	},'text',false)
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })


var Paging = (function () {
    function Paging(elementName, options) {
        this.elementName = elementName;
        this.options = options;
        options.nowPage = options.nowPage >= 1 ? options.nowPage : 1;
        options.pageNum = options.pageNum > 0 ? options.pageNum : 0;
        options.canJump = options.canJump || 0;
        options.showOne = options.showOne || 0;
        options.buttonNum = (options.buttonNum >= 5 ? options.buttonNum : 5) || 7;
        
        this.nowPage = options.nowPage > options.pageNum ? options.pageNum : options.nowPage;
        this.pageNum = options.pageNum < 0 ? 0 : options.pageNum;
        this.canJump = options.canJump;
        this.showOne = options.showOne;
        this.buttonNum = options.buttonNum;
        this.callback = options.callback;
        this.element = document.getElementById(elementName);
        this.init();
    }
    Paging.prototype.init = function () {
        this.createHtml();
    };
    Paging.prototype.createHtml = function () {
        var _this = this;
        var content = [];
        //���pageNumС�ڵ���0����Ⱦ
        if (this.pageNum <= 0) {
            return '';
        }
        //���ֻ��һҳ��������Ϊ����ʾ���򲻽�����Ⱦ
        if (!this.showOne && this.pageNum === 1) {
            this.element.innerHTML = '';
            return '';
        }
        content.push("<ul>");
        content.push("<li id='page_first' class='page_first'>" + "��ҳ" + "</li>");
        content.push("<li id='pag_li_' class='xl-prevPage'><</li>");
        //ҳ������С�ڵ��ڵ�ǰҪչʾҳ��������չʾ����ҳ��
        if (this.pageNum <= this.buttonNum) {
	        
            for (var i = 1; i <= this.pageNum; i++) {
                if (this.nowPage !== i) {
                    content.push("<li id='pag_li_'>" + i + "</li>");
                }
                else {
                    content.push("<li id='pag_li_' class='xl-active' style='background-color: #D1A85F;border-color: #D1A85F;color: #FFF;'>" + i + "</li>");
                }
            }
            
        }
        else if (this.nowPage <= Math.floor(this.buttonNum / 2)) {
	        
            //��ǰҳ��С�ڵ���չʾҳ��������һ�루����ȡ��������1��ʼ
            for (var i = 1; i <= this.buttonNum - 2; i++) {
                if (this.nowPage !== i) {
                    content.push("<li id='pag_li_'>" + i + "</li>");
                }
                else {
                    content.push("<li id='pag_li_' class='xl-active' style='background-color: #D1A85F;border-color: #D1A85F;color: #FFF;'>" + i + "</li>");
                }
            }
            content.push("<li id='pag_li_' class='xl-disabled' style='opacity: .5;cursor: no-drop;'>...</li>");
            content.push("<li id='pag_li_'>" + this.pageNum + "</li>");
            
        }
        else if (this.pageNum - this.nowPage <= Math.floor(this.buttonNum / 2)) {
            //��ǰҳ�����չʾҳ��������һ�루����ȡ����
             
            content.push("<li id='pag_li_'>" + 1 + "</li>");
            content.push("<li id='pag_li_' class='xl-disabled' style='opacity: .5;cursor: no-drop;'>...</li>");
            for (var i = this.pageNum - this.buttonNum + 3; i <= this.pageNum; i++) {
                if (this.nowPage !== i) {
                    content.push("<li id='pag_li_'>" + i + "</li>");
                }
                else {
                    content.push("<li id='pag_li_' class='xl-active' style='background-color: #D1A85F;border-color: #D1A85F;color: #FFF;'>" + i + "</li>");
                }
            }
            
        }
        else {
	         
            //ǰ�벿��ҳ��
            if (this.nowPage - Math.floor(this.buttonNum / 2) <= 0) {
                for (var i = 1; i <= Math.floor(this.buttonNum / 2); i++) {
                    if (this.nowPage !== i) {
                        content.push("<li id='pag_li_'>" + i + "</li>");
                    }
                    else {
                        content.push("<li id='pag_li_' class='xl-active' style='background-color: #D1A85F;border-color: #D1A85F;color: #FFF;'>" + i + "</li>");
                    }
                }
            }
            else {
                content.push("<li id='pag_li_'>" + 1 + "</li>");
                content.push("<li id='pag_li_' class='xl-disabled' style='opacity: .5;cursor: no-drop;'>...</li>");
                for (var i = this.nowPage - Math.floor(this.buttonNum / 2) + (this.buttonNum % 2 == 0 ? 3 : 2); i <= this.nowPage; i++) {
                    if (this.nowPage !== i) {
                        content.push("<li id='pag_li_'>" + i + "</li>");
                    }
                    else {
                        content.push("<li id='pag_li_' class='xl-active' style='background-color: #D1A85F;border-color: #D1A85F;color: #FFF;'>" + i + "</li>");
                    }
                }
            }
            //��벿��ҳ��
            if (this.pageNum - this.nowPage <= 0) {
                for (var i = this.nowPage + 1; i <= this.pageNum; i++) {
                    content.push("<li id='pag_li_'>" + i + "</li>");
                }
            }
            else {
                for (var i = this.nowPage + 1; i <= this.nowPage + Math.floor(this.buttonNum / 2) - 2; i++) {
                    content.push("<li id='pag_li_'>" + i + "</li>");
                }
                content.push("<li id='pag_li_' class='xl-disabled' style='opacity: .5;cursor: no-drop;'>...</li>");
                content.push("<li id='pag_li_'>" + this.pageNum + "</li>");
            }
            
        }
        content.push("<li id='pag_li_' class='xl-nextPage'>></li>");
        if (this.canJump) {
            content.push("<li id='pag_li_' class='xl-jumpText xl-disabled' style='opacity: .5;cursor: no-drop;background-color: rgba(0, 0, 0, 0);border-color: rgba(0, 0, 0, 0);opacity: 1;'>��" + this.pageNum + "ҳ<input type='number' id='xlJumpNum'>ҳ</li>");
            content.push("<li id='pag_li_' class='xl-jumpButton' style='padding: 0 5px;'>��ת</li>");
        }
        content.push("<li id='page_last' class='page_last'>" + "ĩҳ" + "</li>");
        content.push("</ul>");
        
        this.element.innerHTML = content.join('');
        this.element.setAttribute('style', 'margin:20px auto;color:#666;text-align:center;');
        // DOM�������ɺ�ÿ�ε����Ƿ����button
        setTimeout(function () {
            _this.disabled();
            _this.bindClickEvent();
        }, 20);
    };
    Paging.prototype.bindClickEvent = function () {
        var _this = this;
        var liList = this.element.children[0].children;
        var _loop_1 = function (i) {
            liList[i].removeEventListener('click', function () {
                _this.clickEvent(liList[i]);
            });
        };
        for (var i = 0; i < liList.length; i++) {
            _loop_1(i);
        }
        var _loop_2 = function (i) {
            liList[i].addEventListener('click', function () {
                _this.clickEvent(liList[i]);
            });
        };
        for (var i = 0; i < liList.length; i++) {
            _loop_2(i);
        }
    };
    Paging.prototype.clickEvent = function (li) {   //����¼�
        var cla = li.className;
        var num = parseInt(li.innerHTML);
        var nowPage = this.nowPage;
        if (li.className.indexOf('xl-disabled') !== -1 || cla === 'xl-jumpText') {
            return '';
        }
        if (cla === 'xl-prevPage') { //�����һҳ
            if (nowPage >= 1) {
                this.nowPage -= 1;
            }
        }
        else if (cla === 'page_first') { //�����ҳ
            
                this.nowPage = 1;
            
        }
        
         else if (cla === 'page_last') { //���ĩҳ
            
                this.nowPage = this.pageNum;
            
        }
        else if (cla === 'xl-nextPage') { //�����һҳ
            if (nowPage < this.pageNum) {
                this.nowPage += 1;
            }
        }
        else if (cla === 'xl-jumpButton') { //�����ת��ť
            var el = document.getElementById('xlJumpNum');//��ȡҳ��������ֵ
            //û������������ �� ������ҳ�� ��С��0
            if (!(/(^[1-9]\d*$)/.test(Number(el.value))) || Number(el.value) > this.pageNum || Number(el.value) <= 0) {
                alert('������Ϸ���ҳ�룡');
                el.value = ''; //���ҳ�������
                return false;
            } else {
                this.nowPage = Number(el.value);
            }
        } else {
            this.nowPage = num;
        }
        this.createHtml();
        if (this.callback) {
            this.callback(this.nowPage);    //�ص�
        }
    };
    Paging.prototype.disabled = function () {
        var nowPage = this.nowPage;
        var pageNum = this.pageNum;
        var liList = this.element.children[0].children;
        if (nowPage === 1) {
            for (var i = 0; i < liList.length; i++) {
                if (liList[i].className.indexOf('xl-prevPage') !== -1) {
                    liList[i].setAttribute('class', liList[i].getAttribute('class').concat(' xl-disabled'));
                }
            }
        }
        else if (nowPage === pageNum) {
            for (var i = 0; i < liList.length; i++) {
                if (liList[i].className.indexOf('xl-nextPage') !== -1) {
                    liList[i].setAttribute('class', liList[i].getAttribute('class').concat(' xl-disabled'));
                }
            }
        }
    };
    return Paging;
}());
 
 
 
   
 
 
