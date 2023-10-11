/*规则授权*/
var currEditRow="";currEditID="";currPointer="";
var currLibDr="";	/// 知识库类别标记
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "ModelFlag" 	// 实体标记(附加属性值)
var selectEle="";

function initPageDefault(){
	
	//InitPageComponent();	/// 初始化界面控件
	InitPageDataGrid();		/// 初始化界面Datagrid
	InitButton();			/// 初始化界面界面按钮响应
	new Paging('pageSea', {
        nowPage: 1,                 // 当前页
        pageNum: 2,                // 总页数
        buttonNum: 5,               // 要展示的页码数量
        canJump: 0,                 // 是否显示跳转功能跳转  0(默认):不显示    1:显示
        showOne: 0,                 // 只有一页时，是否显示  0:不显示     1(默认):显示
        callback: function (cpage) { //回调函数
            alert(cpage);
        }
    })


	//$(".pagination").html("");
	//$(".pagination").pagination({layout:['first','prev','links','next','last']});
}
// 初始化界面控件
function InitPageComponent()
{
	/// 知识库类型
	var option = {
		panelHeight:"auto",       
	    onLoadSuccess: function () { //数据加载完毕事件
	    	$("#libcombo").combobox('setValue',5)
        },
        onSelect:function(option){
	        currLibDr = option.value;
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("libcombo",url,'',option).init();
}
// 初始化界面DataGrid
function InitPageDataGrid(){

	/// 医院
	///  定义columns
	var hospcolumns=[[
		{field:'desc',title:'医院',width:400}, 
		{field:'rowid',title:'rowid',hidden:true}
	]];
	
	///  定义datagrid
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
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }
	    
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryHospList&rows=100&page=1";
	new ListComponent('hospgrid', hospcolumns, uniturl, hospoption).Init();
	
	
	///职称
	var ctpcolumns=[[  
		{field:'desc',title:'职称',width:400}, 
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
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryCtCptList";
	new ListComponent('cptgrid', ctpcolumns, uniturl, ctpoption).Init();
	
	
	///医生科室
	var docloccolumns=[[  
		{field:'code',title:'科室',width:200,hidden:true}, 
		{field:'desc',title:'科室',width:400}, //qunianpeng 2017/10/9
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
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCCKBGrantAuth&MethodName=QueryDocLocList&Input=";
	new ListComponent('doclocgrid', docloccolumns, uniturl, doclocoption).Init();
	
	///医生
	var doccolumns=[[  
		{field:'desc',title:'医生',width:200},
		{field:'code',title:'工号',width:200},  
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
				//$.messager.alert('错误提示','知识库不能为空!',"error");
				//return;			
			//}           
        }	   
	};
	var uniturl = $URL+"?ClassName=web.DHCSTPHCMADDEXTLIB&MethodName=QueryAccDocList&rows=100&page=1&input=";
	new ListComponent('docgrid',doccolumns, uniturl, docoption).Init();
	
	
	/// 权限列表
	var accitmclumns=[[ 
		{field:'desc',title:'描述',width:580}, 
		{field:'libdr',title:'libdr',hidden:true}, 
		{field:'lib',title:'知识库',width:80,hidden:true}, 
		{field:'ralation',title:'关系',hidden:true},   
		{field:'rowid',title:'rowid',hidden:true},
		{field:'id',title:'id',hidden:true},
		{field:'_parentId',title:'parentId',hidden:true},
		{field:'contrl',title:'控制',hidden:true},
		{field:'chk',title:'选择',hidden:true},
		{field:'dataType',title:'字典表类型',hidden:true}
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
		onLoadSuccess: function (index,data) { //数据加载完毕事件
           $.each(data.rows,function(tmpindex,obj){
	           if (obj._parentId == ""){
		       		return true;		// 退出本次循环
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
/// 查询授权项目
function QueryAccitm(input){
	
	currPointer = input;
	$('#accitmgrid').treegrid('load',{
		Input:input
	
	}); 
}
/// 初始化界面按钮响应
function InitButton(){

	// 科室回车事件
	$('#doclocbarid').bind('keydown',function(event){
		 if(event.keyCode == "13"){			 
			var Input=$.trim($("#doclocbarid").val());
			$('#doclocgrid').datagrid('load',  {  
				Input:Input	
			});
		 }
	});
	
	// 医生回车事件
	$('#doctorno').bind('keydown',function(event){
		 if(event.keyCode == "13") {			 
			 var input=$.trim($("#doctorno").val());  			
			$('#docgrid').datagrid('load',  {  
				input:input	
			});
		 }
　 });

	$("#btnSave").click(function(){
	   	SaveAcc();
    })
}

//保存授权
function SaveAcc()
{
	/*
	if (currPointer == ""){
		$.messager.alert("提示","请选择知识库和授权对象!","info");
		return ;
	}
	*/
	
	var input="";
    var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	/* if ((allCheck == "")||(allCheck == null)){
		$.messager.alert("提示","请选择需要授权的项目后进行保存!","info");
	    return;
	  
	} */
	var exitFlag = 0;
	if ((allCheck == "")||(allCheck == null)){
		$.messager.confirm('提示', '【不选择项目保存时，会清除掉当前用户的授权！】<br/>确定清除吗?', function(r){
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

/// 保存前组织保存数据
function SaveTemp(){
	
	var allCheck = $HUI.treegrid('#accitmgrid').getCheckedNodes();
	var tmpPar = "",ParArr=[],ParInfo ="",checkInfoArr = [];							
	for (var i=0; i<allCheck.length; i++){
		if (allCheck[i]._parentId == ""){	// 上层节点			
			continue;
		}
		else{			
			var checkInfo = allCheck[i].id +":"+allCheck[i].dataType ;	// 勾选的子节点;
			var parRowID = allCheck[i]._parentId;	// 父节点			
			if (ParArr.indexOf(parRowID)==-1){	// 父节点已经存储过
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
	//		selectEle(知识库类型+"^"+作用域+"^"+作用域值)   +"^"+ 操作用户 +"^"+ 客户端ip    +"@"+ 项目id:字典类型^项目id:字典类型!项目id:字典类型
 	input = selectEle +"^"+ LgUserID +"^"+ ClientIPAdd +"@"+ ParInfo; 
	
	Save(input); 

}
 
function Save(ListData){
					
	runClassMethod("web.DHCCKBGrantAuth","SaveAccItm",{"ListData":ListData},function(jsonString){
		if(jsonString != 0){
			$.messager.alert("提示","保存失败:"+jsonString,"error");
		}else{
			$.messager.alert("提示","保存成功","info");
		}
	},'text',false)
}
/// JQuery 初始化页面
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
        //如果pageNum小于等于0则不渲染
        if (this.pageNum <= 0) {
            return '';
        }
        //如果只有一页并且设置为不显示，则不进行渲染
        if (!this.showOne && this.pageNum === 1) {
            this.element.innerHTML = '';
            return '';
        }
        content.push("<ul>");
        content.push("<li id='page_first' class='page_first'>" + "首页" + "</li>");
        content.push("<li id='pag_li_' class='xl-prevPage'><</li>");
        //页面总数小于等于当前要展示页数总数，展示所有页面
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
	        
            //当前页面小于等于展示页数总数的一半（向下取整），从1开始
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
            //当前页面大于展示页数总数的一半（向下取整）
             
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
	         
            //前半部分页码
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
            //后半部分页码
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
            content.push("<li id='pag_li_' class='xl-jumpText xl-disabled' style='opacity: .5;cursor: no-drop;background-color: rgba(0, 0, 0, 0);border-color: rgba(0, 0, 0, 0);opacity: 1;'>共" + this.pageNum + "页<input type='number' id='xlJumpNum'>页</li>");
            content.push("<li id='pag_li_' class='xl-jumpButton' style='padding: 0 5px;'>跳转</li>");
        }
        content.push("<li id='page_last' class='page_last'>" + "末页" + "</li>");
        content.push("</ul>");
        
        this.element.innerHTML = content.join('');
        this.element.setAttribute('style', 'margin:20px auto;color:#666;text-align:center;');
        // DOM重新生成后每次调用是否禁用button
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
    Paging.prototype.clickEvent = function (li) {   //点击事件
        var cla = li.className;
        var num = parseInt(li.innerHTML);
        var nowPage = this.nowPage;
        if (li.className.indexOf('xl-disabled') !== -1 || cla === 'xl-jumpText') {
            return '';
        }
        if (cla === 'xl-prevPage') { //点击上一页
            if (nowPage >= 1) {
                this.nowPage -= 1;
            }
        }
        else if (cla === 'page_first') { //点击首页
            
                this.nowPage = 1;
            
        }
        
         else if (cla === 'page_last') { //点击末页
            
                this.nowPage = this.pageNum;
            
        }
        else if (cla === 'xl-nextPage') { //点击下一页
            if (nowPage < this.pageNum) {
                this.nowPage += 1;
            }
        }
        else if (cla === 'xl-jumpButton') { //点击跳转按钮
            var el = document.getElementById('xlJumpNum');//获取页码输入框的值
            //没有输入正整数 或 大于总页数 或小于0
            if (!(/(^[1-9]\d*$)/.test(Number(el.value))) || Number(el.value) > this.pageNum || Number(el.value) <= 0) {
                alert('请输入合法的页码！');
                el.value = ''; //清空页码输入框
                return false;
            } else {
                this.nowPage = Number(el.value);
            }
        } else {
            this.nowPage = num;
        }
        this.createHtml();
        if (this.callback) {
            this.callback(this.nowPage);    //回调
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
 
 
 
   
 
 
