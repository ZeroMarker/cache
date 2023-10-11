var init = function(){
	var ifFirstLoadPropertyData=true; //是否初次加载-是：true；否：false
	var PreSearchText=""; //属性检索条件
	var CacheDiagProperty={}; //快速检索中属性列表获取
	var CacheDiagPropertyNote={}; //快速检索中属性列表备注获取
	var SelPropertyArr=new Array();
	
	//重载属性列表按钮
	$("#btnReloadPro").click(function (e) { 
		$('#Form_DiagPropertySearchText').searchbox('setValue','')
		$HUI.radio("#SearchModeA").uncheck(); 
		$("#DiagForm").empty();
		//SelPropertyData=""; //未保存的已选属性也需保留
		var SDSRowId=$("#SelSDSRowId").val()
		indexTemplate=undefined;
		LoadPropertyData($("#SelMKBRowId").val(),SDSRowId,indexTemplate);
		CacheDiagProperty={};
		CacheDiagPropertyNote={};	
	 })
	/*****************左侧属性快速检索列表开始*******************************************/
	var ifLoadPropertySearchGrid=true;
	var Form_DiagPropertySearchGrid=$HUI.datagrid("#Form_DiagPropertySearchGrid",{
			/*url:$URL,
			queryParams:{
				ClassName:"web.DHCBL.MKB.SDSStructDiagnos",         ///调用Query时
				QueryName:"GetStructProDetail",
				proTemplId:"",
				indexTemplate:""
			},*/
			columns: [[    
				{field:'text',title:'属性名称',width:200,sortable:true,
				formatter:function(value,rec){ 
						if (rec.note!=undefined){ //鼠标悬浮显示备注
							value="<span class='hisui-tooltip' title='"+rec.note.replace(/<[^>]+>/g,"")+"'>"+value+"</span>" 
						}
						return value;
	                } 
		         },
		        {field:'note',title:'属性备注',width:200,sortable:true,hidden:true},
				{field:'id',title:'属性id',width:200,sortable:true,hidden:true} //11176_1714387_T_SS__P#369071  DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:50, 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			onLoadSuccess:function(data){
				var panel = $(this).datagrid('getPanel');   
		        var tr = panel.find('div.datagrid-body tr');   
		        tr.each(function(){   
		          	$(this).css({"height": "20px"})
		        });  
		        if(ifLoadPropertySearchGrid==true){
					if ((PreSearchText!="")||(indexTemplate!=undefined)){ 
							DiagPropertySearch(PreSearchText,indexTemplate);
							var listArr=new Array();
							var proFrequencyStr=""
							for(i=0;i<$('#Form_DiagPropertySearchGrid').datagrid('getData').total;i++){
								var id = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].id;
								var text = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].text;
								var note = $('#Form_DiagPropertySearchGrid').datagrid('getData').rows[i].note;
								listArr.push({"id":id,"text":text,"note":note});
								proFrequencyStr=proFrequencyStr+"$"+id.split("#")[0]+"#"+id.split("#")[1]
							}
							proFrequencyStr=proFrequencyStr+"$"
							//属性快速检索列表数据再次取前台数组的数据
							for ( var oe in CacheDiagProperty) {
								if (proFrequencyStr.indexOf("$"+oe+"$")<0){
									listArr.push({"id":oe,"text":CacheDiagProperty[oe],"note":CacheDiagPropertyNote[oe]});
								}
							}
							ifLoadPropertySearchGrid=false
							$("#Form_DiagPropertySearchGrid").datagrid("loadData",listArr)
							$('#Form_DiagPropertySearchGrid').datagrid('unselectAll');
					}
		        }
			},
			onClickRow:function(rowIndex,rowData){
				var selected = $('#Form_DiagPropertySearchGrid').datagrid('getSelected');  
				if (selected) { 				
					var id=selected.id; 
					var trids=id.split("#")[0]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var propertyid=id.split("#")[1];
					var childId=trids.split("_")[1];
					var showType=trids.split("_")[2];
					var treeNode=trids.split("_")[4];
					var isTOrP=trids.split("_")[5];
					var tds=$("#"+trids+"").children();
					for (var j=1;j<tds.length;j++){
						//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
						var detailId=""
						var details=$("#"+trids+" td").children();
						for (var k=1;k<details.length;k++){
							if (k==1){
								detailId=details[k].id
							}
						}
						if (showType=="T"){		  
							if ((tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",childId)=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)=="其他文本描述")){
								//其他文本描述给文本框赋值
		 						var Supplement=$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()
		 						if (Supplement==""){
		 							Supplement=selected.text
		 						}else{
		 							Supplement=Supplement+"，"+selected.text
		 						}
		 						$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(Supplement)
		 						$("#"+detailId+"").blur();
							}else{
								var node = $("#"+detailId+"").tree('find', propertyid);
								$("#"+detailId+"").tree("check",node.target);
						        //展示所有父节点  
						        $(node.target).show();  
						        $(".tree-title", node.target).addClass("tree-node-targeted");  
						        //展开到该节点 
						        $("#"+detailId+"").tree("expandTo",node.target);			        
						        //如果是非叶子节点，需折叠该节点的所有子节点  
						        if (!$("#"+detailId+"").tree("isLeaf",node.target)) { 
						        	$("#"+detailId+"").tree("collapse",node.target);
								} 
							}
						}
						if (showType=="C"){
							$("#"+detailId+"").combobox("select",propertyid);
						}
						if (showType=="G"){ //列表
							var rowIndex = $("#"+childId+"_G"+isTOrP).datagrid('getRowIndex', propertyid)
							var colRow=$("#"+childId+"_G"+isTOrP).parent().children().find('tr[datagrid-row-index='+rowIndex+']')
							if(!$("#"+colRow.attr("id")).hasClass('datagrid-row-checked')){
								$("#"+childId+"_G"+isTOrP).datagrid("checkRow",rowIndex)
							}
						}
						if (showType=="CB"){
							//$("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").click();
							$HUI.radio("#"+childId+"_"+propertyid+"_CB"+isTOrP+"").check();
						}
						if (showType=="CG"){
							//$("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").click();
							$HUI.checkbox("#"+childId+"_"+propertyid+"_CG"+isTOrP+"").check();
						}
					}
					CacheDiagProperty={};
					CacheDiagPropertyNote={};
					
				}
			}
		})
		//左侧属性快速检索列表加载方法
		function LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc){
			var SearchMode=$("input[name='SearchMode']:checked").val() //检索模式
			if ((SearchMode==undefined)||(SearchMode=="undefined")) SearchMode=""
			ifLoadPropertySearchGrid=true;
			var opts = $('#Form_DiagPropertySearchGrid').datagrid("options");
			/*var queryParams = new Object(); 
			queryParams.ClassName="web.DHCBL.MKB.SDSStructDiagnos"; 
			queryParams.QueryName="GetStructProDetail";
			queryParams.proTemplId =DKBBCRowId;
			queryParams.indexTemplate =indexTemplate;
			queryParams.desc =desc;
			opts.url = $URL  
			opts.queryParams = queryParams;*/
			opts.url=$URL+"?ClassName=web.DHCBL.MKB.SDSDataFrequency&QueryName=GetStructProDetail&ResultSetType=array&proTemplId="+DKBBCRowId+"&indexTemplate="+indexTemplate+"&desc="+desc+"&SearchMode="+SearchMode;
			$('#Form_DiagPropertySearchGrid').datagrid("load");
		}
		/*****************左侧属性快速检索列表结束*******************************************/
		/*****************中间已选属性列表开始*******************************************/
		$HUI.datagrid("#Form_DiagPropertySelectedGrid",{
			columns: [[    
				{field:'index',title:'index',width:30,sortable:true,hidden:true},
				{field:'titleid',title:'属性标题id',width:60,sortable:true,hidden:true},
				{field:'title',title:'属性标题',width:120,sortable:true,
					formatter:function(value,rec){ 
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+value+"</span>" 
	                } 
				},
				{field:'text',title:'已选属性',width:200,sortable:true,
					formatter:function(value,rec){ 
						var showValue=value
						if ((value!="")&&(value!=undefined)){
							if (value.length>10){
								showValue=value.substr(0,12)+"..."
							}
						}
				   	  //鼠标悬浮显示全部
						return "<span class='hisui-tooltip' title='"+value+"'>"+showValue+"</span>" 
	                } 
		         },
				{field:'id',title:'已选属性id',width:30,sortable:true,hidden:true}
			]],
			pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
			pageSize:100,
			pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
			singleSelect:true,
			showHeader:false,
			idField: 'id',    
			textField: 'text',  
			rownumbers:false,    //设置为 true，则显示带有行号的列。
			fixRowNumber:true,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			resizable:true,
			fixed:true,
			remoteSort:false,  //定义是否从服务器排序数据。true
			sortName:'index',  
    		sortOrder:'asc',
			onClickCell:function(rowIndex, field, value){
				if (field=="title"){
					$("#DiagForm").empty();
					var SDSRowId=$("#SelSDSRowId").val()
					indexTemplate=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1];
					setTimeout(function(){
						LoadPropertyData($("#SelMKBRowId").val(),SDSRowId,indexTemplate);
					},100)
				}else{
					if (value=="") return;
					var trids=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1]
					var childId=trids.split("_")[1];
					var showType=trids.split("_")[2];
					var treeNode=trids.split("_")[4];
					var isTOrP=trids.split("_")[5];
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					var propertyid=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].id
					if (showType=="T"){		  
						if ((tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",childId)=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)=="其他文本描述")){
							scrollToLocation(childId+"_T"+isTOrP+"_"+treeNode);
						}else{
							var node = $("#"+detailId+"").tree('find', propertyid);
							scrollToLocation(node.target.id);
						}
					}
					if (showType=="C"){
						scrollToLocation(trids);//下拉框中的id框为隐藏控件，故根据tr行id定位
					}
					if (showType=="G"){ //列表
						var rowIndex = $("#"+childId+"_G"+isTOrP).datagrid('getRowIndex', propertyid)
						var colRow=$("#"+childId+"_G"+isTOrP).parent().children().find('tr[datagrid-row-index='+rowIndex+']')
						scrollToLocation(colRow.attr("id"))
					}
					if (showType=="CB"){
						scrollToLocation(childId+"_"+propertyid+"_CB"+isTOrP)
					}
					if (showType=="CG"){
						scrollToLocation(childId+"_"+propertyid+"_CG"+isTOrP)
					}
				}
			},
			/*onClickRow:function(rowIndex, rowData){
				//选中已勾选属性内容节点效果
				var trids=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var childId=trids.split("_")[1]
				var showtype=trids.split("_")[2];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				if (tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",treeNode)!="其他文本描述"){
					var nodeid=$('#Form_DiagPropertySelectedGrid').datagrid('getRows')[rowIndex].id
					if ((nodeid!=0)&&(showtype=="T")){
						//选中已勾选属性内容节点
						var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',nodeid); 
						$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('select',node.target); 
					}
				}
			},*/
			onRowContextMenu: function(e, rowIndex, rowData){   //右键菜单
				var $clicked=$(e.target);
				copytext =$clicked.text()||$clicked.val()   //普通复制功能
				
				e.preventDefault();  //阻止浏览器捕获右键事件
				var record=$(this).datagrid("selectRow", rowIndex); //根据索引选中该行  
				$('#selProMenu').menu('show', {    
					  left:e.pageX,  
					  top:e.pageY
				})
			},
			onLoadSuccess: function(data){                      //data是默认的表格加载数据，包括rows和Total
				var mark=1;                                                 //这里涉及到简单的运算，mark是计算每次需要合并的格子数
				for (var i=1; i <data.rows.length; i++) {     //这里循环表格当前的数据
			　　　 		if(data.rows[i]['title'] == data.rows[i-1]['title']){   //后一行的值与前一行的值做比较，相同就需要合并
				　　　　	mark += 1;                                            
				　　　　　　　$(this).datagrid('mergeCells',{ 
				　　　　　　　　　　index: i+1-mark,                 //datagrid的index，表示从第几行开始合并；紫色的内容需是最精髓的，就是记住最开始需要合并的位置
				　　　　　　　　　　field: 'title',                 //合并单元格的区域，就是clomun中的filed对应的列
				　　　　　　　　　　rowspan:mark                   //纵向合并的格数，如果想要横向合并，就使用colspan：mark
				　　　　　　　}); 
			　　　　　　	}else{
			　　　　　　　		mark=1;                                         //一旦前后两行的值不一样了，那么需要合并的格子数mark就需要重新计算
			　　　　　　	}
		　　　　	}
		　}
	});
	function scrollToLocation(scrollToId) {
	    var mainContainer = $('#DiagPanel');
	    var scrollToContainer = $('#'+scrollToId);
	    //非动画效果
	    /*mainContainer.scrollTop(
	    	scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
	    );*/
	    //动画效果
	    mainContainer.animate({
	    	scrollTop: scrollToContainer.offset().top - mainContainer.offset().top + mainContainer.scrollTop()
	    }, 200);
	}
	/*****************中间已选属性列表结束*******************************************/
	//记录基础代码数据使用频次 
	SaveFreq=function(ValueId, ValueDesc, TableName) {
		if (flagSaveFreq=="false") return;
	    var FrequencyStr=TableName+"^"+ValueId+"^"+ValueDesc+"^^"
	    var rtn = tkMakeServerCall("web.DHCBL.BDP.BDPDataFrequency", "SaveData", FrequencyStr)
	}
	//6个字符一换行方法
	function getNewline(val) {  
	    var str = new String(val);  
	    var bytesCount = 0;  
	    var s="";
	    for (var i = 0 ,n = str.length; i < n; i++) {  
	        var c = str.charCodeAt(i);  
	        //统计字符串的字符长度
	        if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {  
	            bytesCount += 1;  
	        } else {  
	            bytesCount += 2;  
	        }
	        //换行
	        s += str.charAt(i);
	        if((bytesCount>=6)&&(n!=3)){  
	        	s = s + '</br>';
	        	//重置
	        	bytesCount=0;
	        } 
	    }  
	    return s;  
	} 
	//诊断查找选择后初始化诊断属性列表页
	LoadPropertyData=function(SDSTermDR,SDSRowId,indexTemplate){
		CacheDiagProperty={};
		CacheDiagPropertyNote={};	
		//console.log(SDSTermDR+","+SDSRowId+","+indexTemplate)
		//下拉树，下拉框，单选框，多选框，列表数据
		var TreeCheckedIdStr="",ComboCheckedIdStr="",RadioCheckedIdStr="",CheckBoxCheckedIdStr="",GridCheckedIdStr=""
		if ((SDSRowId!="")){ //属性修改
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				if(typeof(ServerObject)!="undefined"){ 
					//var ret=cspRunServerMethod(ServerObject.GetData, SDSRowId);
					var ret=tkMakeServerCall(ServerObject.GetData.split("#")[0],ServerObject.GetData.split("#")[1],SDSRowId)
				}else{
					var ret=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnos","GetData",SDSRowId)
				}
			}
		}else{
			if (SelPropertyData!=""){
				var ret=SelPropertyData
			}else{
				var ret="";
			}
		}
		if (ret!=""){
			TreeCheckedIdStr=ret.split("^")[0];
			ComboCheckedIdStr=ret.split("^")[1];
			RadioCheckedIdStr=ret.split("^")[2];
			CheckBoxCheckedIdStr=ret.split("^")[3];
			GridCheckedIdStr=ret.split("^")[4];
		}
		SelPropertyArr=[];
		var DiagFormTool='<tr id="formTemplate" style="display:none;"><td nowrap style="white-space:nowrap;word-break:nowrap" class="td_label"><label for="email">分型1</label></td></tr>'
		$("#DiagForm").append(DiagFormTool)
		var $ff=$("#DiagForm"); //table
		var $templ=$("#formTemplate"); //tr
		var RetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDiaTemplate",SDSTermDR) 
		if (RetStr!=""){
			var RetStrArr=RetStr.split("^");
			var DKBBCRowId=RetStrArr[0]; //属性模板Id
			var emptyInfo=RetStrArr[1];
			var modeJsonInfo=$.parseJSON(RetStrArr[2]);
			if ((indexTemplate=="")||(indexTemplate==undefined)) indexTemplate=DKBBCRowId;
			if (emptyInfo=="") {
				return ;
			}
				$(modeJsonInfo).each(function(index,item){
					var childId=modeJsonInfo[index].catRowId; 
					var childDesc=modeJsonInfo[index].catDesc; 
					var childType=modeJsonInfo[index].catType; //L列表 T树形 TX文本 S引用术语类型 C下拉框
					var showType=modeJsonInfo[index].showType;  //['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					var catFlag=modeJsonInfo[index].catFlag; //Y 表示诊断展示名
					var treeNode=modeJsonInfo[index].treeNode; //起始节点
					var choiceType=modeJsonInfo[index].choiceType; //单选多选配置：S单选;D多选
					var ifRequired=modeJsonInfo[index].ifRequired; //是否必填项:Y是；N否
					var isTOrP=modeJsonInfo[index].isTOrP; //引用属性：P，引用术语:T
					
					var trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
					var trName=childDesc+"_"+ifRequired;
					var proSelectFlag= true;//默认单选
					if (choiceType=="D"){
						proSelectFlag= false; //根据诊断模板获取多选
					}else{
						proSelectFlag= true;
					}
					if (childType=="L"){
						if (isTOrP=="P"){
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListDetailInfo", "", childId, "0", "1000");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTPDRowId';  
							var C_textField='comDesc'; //展示名
						}else{ //术语标识
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetListTermJsonForDoc", "", childId, "", "1000", "1");
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc'; //中心词
						}
					}
					if (childType=="T"){
						if (isTOrP=="P"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeDetailJson&id="+treeNode+"&property="+childId
						}else{ //术语标识
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeTermJsonForDoc&id="+treeNode+"&base="+childId
						}
					}
					if ((childType=="TX")||(childType=="TA")||(childType=="R")||(childType=="CB")||(childType=="C")){
						var TXRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetTextInfo",childId); 
					}
					if (childType=="S"){
						if ((showType=="C")||(showType=="CB")||(showType=="CG")||(showType=="G")) { //引用术语 展示为下拉框
							var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseList", childId, showType, ""); 
							ListRetStr=eval("("+ListRetStr+")");
							var C_valueField='MKBTRowId';  
							var C_textField='MKBTDesc';
						}
						else if (showType=="T"){
							var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetDocSourseTreeJson&LastLevel=&property="+childId
						}
						else{
							var SRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocSourseDetailInfo",childId); 
						}
					}
					if (childType=="P"){
						var ListRetStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocPropertyList",childId, ""); 
						ListRetStr=eval("("+ListRetStr+")")
						if (showType=="C") {
							var C_valueField='catRowId';  
							var C_textField='catDesc';
						}
					}
					if (childType=="SS"){
						var TreeRetUrl="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetSSProDetailJsonForDoc&property="+childId
					}
					var tool=$templ.clone();
					tool.removeAttr("style");
					tool.removeAttr("id");
					tool.attr("id",trId);
					tool.attr("lang",trName); //201917 title
					tool.addClass("dynamic_tr");
					tool.addClass("tr_dispaly");
					$ff.append(tool);
					//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表,隐藏其他属性列表
				 	if ((indexTemplate!=undefined)&&(indexTemplate!="")&&(indexTemplate!=DKBBCRowId)){
				 		if ((trId)!=indexTemplate){
					 		$(tool).css("display","none")
					 	}else{
					 		$(tool).css("display","")
					 	}
				 	}
				
					//属性名称列设置颜色交替变换
					if (index%2==0){
						$("td",tool).css("backgroundColor","#EEFAF4")
					}else{
						$("td",tool).css("backgroundColor","#FBF9F2")
					}
					//诊断属性悬浮显示属性名
					$("td",tool).tooltip({
					    position: 'right',
					    content: '<span style="color:#fff">'+childDesc+'</span>',
					    onShow: function(){
							$(this).tooltip('tip').css({
								backgroundColor: '#666',
								borderColor: '#666'
							});
					    }
					});
					$("label",tool).removeAttr("style");
					//['C','下拉框'],['T','下拉树'],['TX','文本框'],['TA','多行文本框'],['CB','单选框'],['CG','复选框']
					//必填项区分
					if (ifRequired=="Y"){
						$("label",tool).html("<font color=red>*</font>"+getNewline(childDesc));
					}else{
						$("label",tool).html(getNewline(childDesc));
					}
				
					//诊断属性单击事件gss
				     $("#"+DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP).on("click",function(event){ 
						var $dynamic_tr=$(".dynamic_tr"); 
						for (var i=0;i<($dynamic_tr.length);i++){
							var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
							if (trids!=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP)
							{
								continue;
							}
							var id=trids.split("_")[0]; //诊断模板属性id
							var showtype=trids.split("_")[2];
							var tds=$("#"+trids+"").children();
							for (var j=1;j<tds.length;j++){
								//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
								var detailId=""
								var details=$("#"+trids+" td").children();
								for (var k=1;k<details.length;k++){
									if (k==1){
										detailId=details[k].id
									}
								}
								var type=detailId.split("_")[detailId.split("_").length-2];
								if (type=="T"){
									var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
									for (var k=0;k<unCheckedNodes.length;k++){
										var nodeId=unCheckedNodes[k].id;
										var node = $("#"+detailId+"").tree('find', nodeId);
                      					$("#"+node.target.id).css("display","");
									}
										$("#"+trids).css("display","table-row");
								}
							}
						}
						
					}); 
					var FindSelectFlag=0;
					//文本框
					if (showType=="TX"){
						if (childType=="S"){
							var TXText=SRetStr.split("[A]")[2];
							var TXId=SRetStr.split("[A]")[1];
						}else{
						    var TXText=TXRetStr.split("[A]")[1];
						    var TXId=TXRetStr.split("[A]")[0];
						}
						var TX_tool="<td><label id='"+childId+"_"+TXId+"_TX"+isTOrP+"'>"+TXText+"</label></td>"  
						tool.append(TX_tool);
					}
					//多行文本框
					if (showType=="TA"){
						var TAId=""
						if (childType=="S"){
							var TAText=SRetStr.split("[A]")[2];
							TAId=SRetStr.split("[A]")[1];
						}else{
							TAId=TXRetStr.split("[A]")[0];
							var TAText=TXRetStr.split("[A]")[1];
						}
						var TA_tool="<td><textarea disabled='disabled' style='width:98%;background:transparent;border:0px;' id='"+childId+"_"+TAId+"_TA"+isTOrP+"'>"+TAText+"</textarea></td>"  
						tool.append(TA_tool);
					}
					//单选框
					if (showType=="CB"){
						var FindSelectCBFlag=0;
						var CBRetStr = ListRetStr;
						var TA_tool="";
						for (var k=0;k<CBRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CBId=CBRetStr.data[k].MKBTRowId;
		                        var CBDesc=CBRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CBId=CBRetStr.data[k].MKBTRowId;
		                        	var CBDesc=CBRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CBId=CBRetStr.data[k].catRowId;
		                        	var CBDesc=CBRetStr.data[k].catDesc;
								}else{
									var CBId=CBRetStr.data[k].MKBTPDRowId;
		                        	var CBDesc=CBRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+RadioCheckedIdStr+"&").indexOf("&"+CBId+"&")>=0){
		                        //var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"' checked='checked'/>"+"<span>"+CBDesc+"</span>"
		                        var OneTA_tool="<input type='radio' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"' label='"+CBDesc+"' checked='checked'/>"
		                    	FindSelectFlag=1;
		                    	FindSelectCBFlag=1;
		                    	ifFirstLoadPropertyData=true;
		                    	SaveSelPropertyData(index,"selpro"+trId,childDesc,CBId,CBDesc,"add")
		                    }else{
			                    //var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"'/>"+"<span>"+CBDesc+"</span>"
		                    	var OneTA_tool="<input type='radio' name='"+childId+"_"+index+"_CB"+isTOrP+"'"+"id='"+childId+"_"+CBId+"_CB"+isTOrP+"' label='"+CBDesc+"'/>"
			                }
			                
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						if (FindSelectCBFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$HUI.radio("[name='"+childId+"_"+index+"_CB"+isTOrP+"']",{
						 	onChecked:function(e,value){
						 		ifFirstLoadPropertyData=false;
							   	if (e.target.id.indexOf("_CB")>=0){
							   		var id=e.target.id.split("_")[1];
							   		var text=$(e.target).attr("label") //$("#"+e.target.id+"").next().text();
							   		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") //切换之前先清除
							   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
							   		GetSelectedPropertyStr();
							   		InitSmartTip("","","","");
							   	}
				            },
				            onUnchecked:function(e,value){
				            	ifFirstLoadPropertyData=false;
							   	if (e.target.id.indexOf("_CB")>=0){
							   		var id=e.target.id.split("_")[1];
							   		var text=$(e.target).attr("label") //$("#"+e.target.id+"").next().text();
							   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"remove")
							   		GetSelectedPropertyStr();
							   		InitSmartTip("","","","");
							   	}
				            }
						});
						/*$('input:radio').click(function (e) { 
						   ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CB")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") //切换之前先清除
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
						   		GetSelectedPropertyStr();
						   		InitSmartTip("","","","");
						   }
						})*/
					}
					//多选框
					if (showType=="CG"){
						var FindSelectCGFlag=0;
						var CGRetStr = ListRetStr 				
						var TA_tool="";
						for (var k=0;k<CGRetStr.data.length;k++){
							if (isTOrP=="T"){ //术语标识
								var CGId=CGRetStr.data[k].MKBTRowId;
		                        var CGDesc=CGRetStr.data[k].MKBTDesc;
							}else{
								if (childType=="S"){
									var CGId=CGRetStr.data[k].MKBTRowId;
		                        	var CGDesc=CGRetStr.data[k].MKBTDesc;
								}else if(childType=="P"){
									var CGId=CGRetStr.data[k].catRowId;
		                        	var CGDesc=CGRetStr.data[k].catDesc;
								}else{
									var CGId=CGRetStr.data[k].MKBTPDRowId;
		                        	var CGDesc=CGRetStr.data[k].comDesc;
								}
							}
	                        if (("&"+CheckBoxCheckedIdStr+"&").indexOf("&"+CGId+"&")>=0){
		                        //var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"' checked='checked'/>"+"<span>"+CGDesc+"</span>"
		                   		var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"' label='"+CGDesc+"' checked='checked'/>"
		                   		FindSelectFlag=1;
		                   		FindSelectCGFlag=1;
		                        ifFirstLoadPropertyData=true;	
		                        SaveSelPropertyData(index,"selpro"+trId,childDesc,CGId,CGDesc,"add")
		                    }else{
			                    //var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"'/>"+"<span>"+CGDesc+"</span>"
			                	var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG"+isTOrP+"'"+"id='"+childId+"_"+CGId+"_CG"+isTOrP+"' label='"+CGDesc+"' />"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
						
						if (FindSelectCGFlag==0){
							SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
						}
						$HUI.checkbox("[name='"+childId+"_"+index+"_CG"+isTOrP+"']",{
							onChecked:function(e,value){
								ifFirstLoadPropertyData=false;
							    if (e.target.id.indexOf("_CG")>=0){
							   		var id=e.target.id.split("_")[1];
							   		var text=$(e.target).attr("label") //$("#"+e.target.id+"").next().text();
							   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
							   		GetSelectedPropertyStr();
							   		InitSmartTip("","","","");
							    }
							},
							onUnchecked:function(e,value){
								ifFirstLoadPropertyData=false;
							    if (e.target.id.indexOf("_CG")>=0){
							   		var id=e.target.id.split("_")[1];
							   		var text=$(e.target).attr("label") //$("#"+e.target.id+"").next().text();
							   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"remove")
							   		GetSelectedPropertyStr();
							   		InitSmartTip("","","","");
							    }
							}
						});
						
						/*$('input:checkbox').click(function (e) { 
						   ifFirstLoadPropertyData=false;
						   if (e.target.id.indexOf("_CG")>=0){
						   		var id=e.target.id.split("_")[1];
						   		var text=$("#"+e.target.id+"").next().text();
						   		if (e.target.checked==true){
						   			var SelPropertyType="add"
						   		}else{
						   			var SelPropertyType="remove"
						   		}
						   		SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,SelPropertyType)
						   		GetSelectedPropertyStr();
						   		InitSmartTip("","","","");
						   }
						})*/
					}
					//下拉框
					if (showType=="C"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Combo_tool="<td><input class='hisui-combobox' id='"+childId+"_C"+isTOrP+"' /></td>" 
						tool.append(Combo_tool);
						$HUI.combobox("#"+childId+"_C"+isTOrP+"",{
							editable: true,
							multiple:false,
							width:'200',
							//panelHeight:'auto',
							//selectOnNavigation:true,
						  	valueField:C_valueField,   
						  	textField:C_textField,
						  	data:Data,
                			formatter:function(row){ // 鼠标悬浮显示备注
						  		if (childType=="L"){ 
						  			if (isTOrP=="P"){
										if (row.MKBTPDRemark!=""){
											return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark.replace(/<[^>]+>/g,"")+'">'+row.comDesc+'</span>';
										}else{
											return row.comDesc;
										}
						  			}else{ //术语标识
						  				return row.MKBTDesc;
						  			}
						  		}else if (childType=="S"){
						  			return row.MKBTDesc;
						  		}else if (childType=="P"){
						  			return row.catDesc;
						  		}else{
						  			return row.comDesc;
						  		}
							},
						  	onLoadSuccess:function(){
							  	if(ComboCheckedIdStr!=""){
							  		var id=""
								  	var text=""
								  	var ListData=$(this).combobox('getData');
								  	for (var m=0;m<ListData.length;m++){
								  		if (isTOrP=="T"){ //术语标识
								  			if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
											  	id=ListData[m].MKBTRowId
											  	text=ListData[m].MKBTDesc
											}
								  		}else{
										  	if (childType=="S"){
											  	if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
												  	id=ListData[m].MKBTRowId
												  	text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
												  	id=ListData[m].catRowId
												  	text=ListData[m].catDesc
												}
											}else{
												if (("&"+ComboCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
												  	id=ListData[m].MKBTPDRowId
												  	text=ListData[m].comDesc
												}
											}
								  		}
								  		FindSelectFlag=1;
									}
									$(this).combobox('setValue', id);
								  	SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
									ifFirstLoadPropertyData=true;
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onShowPanel:function(){
								if(Data==""){
									$("#"+childId+"_C"+isTOrP+"").combobox("hidePanel");//没有下拉数据时，禁止下拉列表显示，防止点击空白的下拉列表后，属性列表隐藏，空白的下拉列表跑到页面左上角
								}else{
									if (Data.length < 7) {  
										$("#"+childId+"_C"+isTOrP+"").combobox('panel').height("auto"); //下拉数据较少时，下拉面板高度自适应
							        }else{
							        	$("#"+childId+"_C"+isTOrP+"").combobox('panel').height(200); 
							        }
								}
							},
							onSelect:function(record){
								var id=""
                				var text=""
                				if (isTOrP=="T"){
                					id=record.MKBTRowId
                					text=record.MKBTDesc;
                				}else{
                				 	if (childType=="S"){
                				 		id=record.MKBTRowId
						  				text=record.MKBTDesc;
							  		}else if (childType=="P"){
							  			id=record.catRowId
							  			text=record.catDesc;
							  		}else{
							  			id=record.MKBTPDRowId
							  			text=record.comDesc;
							  		}
                				}
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove") 
                				SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
                				GetSelectedPropertyStr();
                				InitSmartTip("","","","");
                				
							},
              				onChange:function(newValue, oldValue){
								if ((newValue=="")&&(ifFirstLoadPropertyData!=true)){
									SaveSelPropertyData(index,"selpro"+trId,childDesc,oldValue,"","remove") //清空下拉框数据时清除已选列表数据
									ifFirstLoadPropertyData=false;
									GetSelectedPropertyStr();//20180313bygss	
									InitSmartTip("","","","");
									
								}
							}
						});
					}
					//列表
					if (showType=="G"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Grid_tool="<td ><table style='width:200px;max-height:200px;' id='"+childId+"_G"+isTOrP+"' border='false'></table></td>" 
						tool.append(Grid_tool);
						$HUI.datagrid("#"+childId+"_G"+isTOrP,{
							columns: [[
								 {field:'ck',checkbox:true,
								 	styler : function(value, row, index) {
										return 'border:0;';
									}}, 
			  					 {field:C_valueField,title:"ID",width:40,hidden:true},
			  					 {field:C_textField,title:'描述',width:80,
			  					 	styler : function(value, row, index) {
										return 'border:0;';
									},
									formatter:function(value,row,index){ // 鼠标悬浮显示备注
								  		if (childType=="L"){ 
								  			if (isTOrP=="P"){
												if ((row.MKBTPDRemark!="")&&(row.MKBTPDRemark!=undefined)){
													return '<span class="hisui-tooltip" title="'+row.MKBTPDRemark.replace(/<[^>]+>/g,"")+'">'+row.comDesc+'</span>';
												}else{
													return row.comDesc;
												}
								  			}else{ //术语标识
								  				return row.MKBTDesc;
								  			}
								  		}else if (childType=="S"){
								  			return row.MKBTDesc;
								  		}else if (childType=="P"){
								  			return row.catDesc;
								  		}else{
								  			return row.comDesc;
								  		}
									}
								}
							]],  //列信息
							showHeader:false,
							checkbox:true,
							checkOnSelect:false,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框
							selectOnCheck:false,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
							pagination: false,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
							singleSelect:proSelectFlag,
							idField:C_valueField, 
							rownumbers:false,    //设置为 true，则显示带有行号的列。
							fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
							remoteSort:false,  //定义是否从服务器排序数据。true
							data:Data,
							onLoadSuccess:function(data){
								if(GridCheckedIdStr!=""){
								  	var ListData=$(this).datagrid('getRows');
								  	for (var m=0;m<ListData.length;m++){
								  		var id=""
								  		var text=""
								  		if (isTOrP=="T"){ //术语标识
								  			if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
											  	id=ListData[m].MKBTRowId
											  	text=ListData[m].MKBTDesc
											}
								  		}else{
										  	if (childType=="S"){
											  	if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTRowId+"&")>=0){
												  	id=ListData[m].MKBTRowId
												  	text=ListData[m].MKBTDesc
												}
											}
											if (childType=="P"){
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].catRowId+"&")>=0){
												  	id=ListData[m].catRowId
												  	text=ListData[m].catDesc
												}
											}else{
												if (("&"+GridCheckedIdStr+"&").indexOf("&"+ListData[m].MKBTPDRowId+"&")>=0){
												  	id=ListData[m].MKBTPDRowId
												  	text=ListData[m].comDesc
												}
											}
								  		}
								  		FindSelectFlag=1;
								  		ifFirstLoadPropertyData=true;
								  		if (id!=""){
											var rowIndex=$(this).datagrid("getRowIndex",id)
											$(this).datagrid("checkRow",rowIndex)
								  		}
									}
								}else{
									SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
								}
							},
							onCheck:function(rowIndex,rowData){
								var id=""
                				var text=""
                				if (isTOrP=="T"){
                					id=rowData.MKBTRowId
                					text=rowData.MKBTDesc;
                				}else{
                				 	if (childType=="S"){
                				 		id=rowData.MKBTRowId
						  				text=rowData.MKBTDesc;
							  		}else if (childType=="P"){
							  			id=rowData.catRowId
							  			text=rowData.catDesc;
							  		}else{
							  			id=rowData.MKBTPDRowId
							  			text=rowData.comDesc;
							  		}
                				}
								if (proSelectFlag==true){//单选模式
									var rows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked")
									if(rows.length>1){ 
										for (var i=0;i<rows.length;i++){
											var ids=""
			                				if (isTOrP=="T"){
			                					ids=rows[i].MKBTRowId
			                				}else{
			                				 	if (childType=="S"){
			                				 		ids=rows[i].MKBTRowId
										  		}else if (childType=="P"){
										  			ids=rows[i].catRowId
										  		}else{
										  			ids=rows[i].MKBTPDRowId
										  		}
			                				}
											if (ids==id) {
												continue
											}
											var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",ids)
											$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
										}
								    }
								}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,text,"add")
								ifFirstLoadPropertyData=false;
                				GetSelectedPropertyStr();
                				InitSmartTip("","","","");
							},
							onUncheck:function(rowIndex,rowData){
								var id=""
                				var text=""
                				if (isTOrP=="T"){
                					id=rowData.MKBTRowId
                					text=rowData.MKBTDesc;
                				}else{
                				 	if (childType=="S"){
                				 		id=rowData.MKBTRowId
						  				text=rowData.MKBTDesc;
							  		}else if (childType=="P"){
							  			id=rowData.catRowId
							  			text=rowData.catDesc;
							  		}else{
							  			id=rowData.MKBTPDRowId
							  			text=rowData.comDesc;
							  		}
                				}
								SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove") 
								ifFirstLoadPropertyData=false;
								GetSelectedPropertyStr();	
								InitSmartTip("","","","");
							}
						})
					}
					//下拉树
					if (showType=="T"){
						if (childDesc=="文本"){
							//其他文本描述放属性列表中作为文本录入框，存到补充诊断字段
							var TA_tool="<td><textarea style='width:250px;height:80px' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></textarea></td>"  
							tool.append(TA_tool);
							$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val($("#SelSDSSupplement").val())
							$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").unbind('blur').blur(function(){
	 							 $("#SelSDSSupplement").val($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val())
	 							 if ($("#SelSDSSupplement").val()!=""){
							  	  		SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","remove")
							  	  }
							  	  ifFirstLoadPropertyData=false;
							  	  if ($("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val()!=""){
							  	 		SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val(),"add")
							  	  }
							})
							if (($("#SelSDSSupplement").val()!="")&&(($("#SelSDSSupplement").val()!=undefined))){
								SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#SelSDSSupplement").val(),$("#SelSDSSupplement").val(),"add")
							}else{
								SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add") //初始化已选属性文本标题
							}
						}else{
								var tmpTreeCheckedIdStr=TreeCheckedIdStr;
								var FindSelectFlag=0;
								var Tree_tool="<td width='200'><ul class='hisui-tree' id='"+childId+"_T"+isTOrP+"_"+treeNode+"'></ul></td>"
								tool.append(Tree_tool);
								var tree=$HUI.tree("#"+childId+"_T"+isTOrP+"_"+treeNode+"",{
									checkbox:true,
									//onlyLeafCheck:true,
									lines:true,
									multiple:proSelectFlag,
									cascadeCheck:false,
									//data:TreeRetStr,
									url:TreeRetUrl, 
									formatter:function(node){
										if (childType=="T"){
			              					//鼠标悬浮显示备注
			                  				var remark=node.text.split("^")[3].split("</span>")[0];
											if (remark!=""){
												return '<span class="hisui-tooltip" title="'+remark.replace(/<[^>]+>/g,"")+'">'+node.text+'</span>';
											}else{
												return node.text;
											}
										}else{
											return node.text;
										}
									},
									onContextMenu: function(e, node){ //诊断属性右键菜单gss   
											e.preventDefault();  //阻止右键默认事件 
										    $("#NodeMenu").empty(); //	清空已有的菜单
											$(this).tree('select',node.target);
											
											//if(flagLoadSmartTip==true){ //结构化诊断调用
												if(TermPermission=="Y"){ //是否有权限
													$('#NodeMenu').menu('appendItem', {
														text:"知识点",
														iconCls:'icon-img',
														onclick:function(){
															var height=parseInt(window.screen.height)-300;
															var width=parseInt(window.screen.width)-300;
															var repUrl=""
															if (isTOrP=="P"){
																repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+menuid+"&TermID="+SDSTermDR+"&ProId="+childId+"&detailId="+node.id+""; 
															}else{
																var termmenuid=tkMakeServerCall("web.DHCBL.MKB.MKBTermBase","GetMenuId",childDesc); 
																repUrl="dhc.bdp.mkb.mkblistterm.csp?BDPMENU="+termmenuid+"&TermID="+node.id+"&ProId="; 
															}
															if ("undefined"!==typeof websys_getMWToken){
																repUrl += "&MWToken="+websys_getMWToken()
															}
															$("#myWinMenuTerm").show();  
															var myWinMenuTerm = $HUI.dialog("#myWinMenuTerm",{
																resizable:true,
																title:'知识点',
																width:width,
																height:height,
																modal:true,
																content:'<iframe id="menuTerm" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
															});
														}
													})
												}
												if(WikiPermission=="Y"){ //是否有权限
													$('#NodeMenu').menu('appendItem', {
														text:"医为百科",
														iconCls:'icon-book-green',
														onclick:function(){
															var height=parseInt(window.screen.height)-300;
															var width=parseInt(window.screen.width)-300;
															var repUrl="dhc.bdp.mkb.mkbencyclopedia.csp?base="+base+"&id="+SDSTermDR;
															if ("undefined"!==typeof websys_getMWToken){
																repUrl += "&MWToken="+websys_getMWToken()
															}
															$("#myWinMenuWiki").show();  
															var myWinMenuTerm = $HUI.dialog("#myWinMenuWiki",{
																resizable:true,
																title:'医为百科',
																width:width,
																height:height,
																modal:true,
																content:'<iframe id="menuTerm" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
															});
														}
													})
												}
											//}
											$('#NodeMenu').menu('appendItem', {
												text:"关联ICD",
												iconCls:'icon-icd',
												onclick:function(){
													var height=parseInt(window.screen.height)-300;
													var width=parseInt(window.screen.width)-300;
													var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+SDSTermDR+"-"+childId+":"+node.id+"&version="+wordVersion+"&dblflag=N&DiagnosValue="; 
													if ("undefined"!==typeof websys_getMWToken){
														repUrl += "&MWToken="+websys_getMWToken()
													}
													$("#myWinMenuICD").show();  
													var myWinMenuICD = $HUI.dialog("#myWinMenuICD",{
														resizable:true,
														title:'关联ICD',
														width:width,
														height:height,
														modal:true,
														content:'<iframe id="menuTerm" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
													});
												}
											})
											$('#NodeMenu').menu('appendItem', {
												text:"相关文献",
												iconCls:'icon-book',
												onclick:function(){
													var height=parseInt(window.screen.height)-300;
													var width=parseInt(window.screen.width)-300;
					                            	var repUrl="dhc.bdp.mkb.mkbrelateddocuments.csp?diag="+SDSTermDR+"-"+childId+":"+node.id+""; 
					                            	if ("undefined"!==typeof websys_getMWToken){
														repUrl += "&MWToken="+websys_getMWToken()
													}
													$("#myWinMenuDocu").show();  
													var myWinMenuDocu = $HUI.dialog("#myWinMenuDocu",{
														resizable:true,
														title:'相关文献',
														width:width,
														height:height,
														modal:true,
														content:'<iframe id="menuDocu" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
													});
												}
											})
											$('#NodeMenu').menu('appendItem', {
												text:"推荐评估表",
												iconCls:'icon-paper-blue-line',
												onclick:function(){
													if ($("#assul").length>0){
														$("#assul").remove();
														$("#assul").children().remove();
													}
													var height=parseInt(window.screen.height)-400;
													var width=parseInt(window.screen.width)-800;
													var assStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetAssessment",SDSTermDR+"-"+childId+":"+node.id)
					                            	if ((assStr!="")&(assStr!=null)){
														var assTitleTool='<ul id="assul" class="tip-ul"></ul>'
														$("#RelatedAssessment").append(assTitleTool);
														var ass=assStr.split("&%")
														for (var i=0;i<ass.length;i++){
															//var id=i+1;
															var assId=ass[i].split("&^")[0];
															var assDesc=ass[i].split("&^")[1];
															var id=assId;
															var assTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="Ass'+id+'" class="tip-title" href="#" onclick="viewAss('+id+","+assId+')">'+assDesc+'</a></div><p class="tip-note" style="display:none" id="PTAssScore'+id+'">总分：<span id="AssScore'+id+'"></span></p><p class="tip-note" style="display:none" id="PTAssRank'+id+'">风险评估：<span id="AssRank'+id+'"></span></p><p class="tip-note" style="display:none" id="PTAssDesc'+id+'">结论：<span id="AssDesc'+id+'"></span></p><span style="display:none" id="AssValue'+id+'"></span></li>';
															$("#assul").append(assTool);
															
															var SDSRowId=$("#SelSDSRowId").val()
															if (SDSRowId!=""){
																var assInfo=tkMakeServerCall("web.DHCBL.MKB.SDSAssessment","GetInfo",SDSRowId,assId); 
																if (assInfo!=""){
																	$("#AssScore"+id).text(assInfo.split("&%")[0]);
																	$("#AssDesc"+id).text(assInfo.split("&%")[1]);
																	$("#AssRank"+id).text(assInfo.split("&%")[2]);
																	$("#AssValue"+id).text(assInfo.split("&%")[3]);
																	
																	$("#PTAssScore"+id).css("display","");
																	$("#PTAssDesc"+id).css("display","");
																	$("#PTAssRank"+id).css("display","");
																}
															}
															
														}
														$("#assul").append("</br>");
													}else{
														$.messager.popover({msg: '不存在推荐评估表！',type:'success',timeout: 1000});
														return;
													}
													$("#myWinMenuAss").show();  
													var myWinMenuAss = $HUI.dialog("#myWinMenuAss",{
														resizable:true,
														title:'推荐评估表',
														width:width,
														height:height,
														modal:true
													});
													
													//推荐评估表页面弹窗
													viewAss=function(id,assessmentId){
														var allvalue=tkMakeServerCall("web.DHCBL.MKB.SDSAssessment","GetValue",$("#SelSDSRowId").val(),assessmentId); 
														var repUrl="dhc.bdp.mkb.mkbassessment.csp?id="+assessmentId+"&sdflag=sd&allvalue="+allvalue+""
														if ("undefined"!==typeof websys_getMWToken){
															repUrl += "&MWToken="+websys_getMWToken()
														}
														$("#myWinAssessment").show();  
														var myWinAssessment = $HUI.dialog("#myWinAssessment",{
															resizable:true,
															title:'推荐评估表',
															width:$(window).width()*92/100,
															height:$(window).height()*92/100,
															modal:true,
															content:'<iframe id="Assessment" frameborder="0" src='+repUrl+' width="99%" height="98%"></iframe>',
															buttonAlign : 'center',
															buttons:[{
																text:'保存',
																handler:function(){
																	if ($("#SelSDSRowId").val()==""){
																		$.messager.alert("提示","请先保存诊断");
																		return;	
																	}
																	var Score=document.getElementById('Assessment').contentWindow.document.getElementById("allscore").innerText
																	var Desc=document.getElementById('Assessment').contentWindow.document.getElementById("result").innerText
																	var Rank=document.getElementById('Assessment').contentWindow.document.getElementById("grade").innerText
																	var Value=document.getElementById('Assessment').contentWindow.document.getElementById("allvalue").value
																	if(Score==""){
																		$.messager.alert("提示","请先计算总分");
																		return;	
																	}
																	$("#AssScore"+id).text(Score);
																	$("#AssDesc"+id).text(Desc);
																	$("#AssRank"+id).text(Rank);
																	$("#AssValue"+id).text(Value);
																	
																	$("#PTAssScore"+id).css("display","");
																	$("#PTAssDesc"+id).css("display","");
																	$("#PTAssRank"+id).css("display","");
																	if (Score!=""){
																		var info=Score+"^"+Desc+"^"+Rank+"^"+id+"^"+Value
																		$.ajax({
																			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSAssessment&pClassMethod=SaveAssessment",  
																			data:{
																				"StructRowId":$("#SelSDSRowId").val(),    
																				"info":info
																			},  
																			type:"POST",
																			success: function(data){
																				  var data=eval('('+data+')'); 
																				  if (data.success == 'true') {
																					 		myWinAssessment.close();
																					 }
																					else { 
																						var errorMsg ="保存失败！"
																						if (data.info) {
																							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
																						}
																						$.messager.alert('操作提示',errorMsg,"error");
																					}		
																			}
																		})
																	}
																}
															},{
																text:'关闭',
																handler:function(){
																	myWinAssessment.close();
																}
															}]
														});
													}
													
												}
											})
											$('#NodeMenu').menu('appendItem', {
												text:"同义诊断",
												iconCls:'icon-adm-same',
												onclick:function(){
													if ($("#tydiagul").length>0){
														$("#tydiagul").remove();
														$("#tydiagul").children().remove();
													}
													var height=parseInt(window.screen.height)-400;
													var width=parseInt(window.screen.width)-800;
													var tydiagStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetTYZD",SDSTermDR+"-"+childId+":"+node.id)
													if ((tydiagStr!="")&(tydiagStr!=null)){
														var tydiagTitleTool='<ul id="tydiagul" class="tip-ul"></ul>'
														$("#RelatedTYDiag").append(tydiagTitleTool);
														var tydiag=tydiagStr.split("&%")
														for (var i=0;i<tydiag.length;i++){
															var id=i+1;
															var tydiagId=tydiag[i].split("&^")[0];
															var tydiagDesc=tydiag[i].split("&^")[1];
															var tydiagTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><span id="synony'+id+'" class="tip-title" href="#" >'+tydiagDesc+'</span><span id="synonyid'+id+'" style="display:none">'+tydiagId+'</span></div></li>';
															$("#tydiagul").append(tydiagTool);   
														}
														$("#tydiagul").append("<br>"); 
													}else{
														$.messager.popover({msg: '不存在同义诊断！',type:'success',timeout: 1000});
														return;
													}
													$("#myWinMenuTY").show();  
													var myWinMenuTY = $HUI.dialog("#myWinMenuTY",{
														resizable:true,
														title:'同义诊断',
														width:width,
														height:height,
														modal:true
													});
												}
											})
											$('#NodeMenu').menu('appendItem', {
												text:"鉴别诊断",
												iconCls:'icon-find-adm',
												onclick:function(){
													if ($("#jbdiagul").length>0){
														$("#jbdiagul").remove();
														$("#jbdiagul").children().remove();
													}
													var height=parseInt(window.screen.height)-400;
													var width=parseInt(window.screen.width)-800;
					                            	var jbdiagStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetJBZD",SDSTermDR+"-"+childId+":"+node.id)
													if ((jbdiagStr!="")&(jbdiagStr!=null)){
														var jbdiagTitleTool='<ul id="jbdiagul" class="tip-ul"></ul>';
														$("#RelatedJBDiag").append(jbdiagTitleTool);
														var jbdiag=jbdiagStr.split("&%")
														for (var i=0;i<jbdiag.length;i++){
															var jbdiagDesc=jbdiag[i].split("&^")[0];
															var jbdiagNote=jbdiag[i].split("&^")[1];
															var jbdiagTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><span>'+jbdiagDesc+'</span></div><p style="margin-left:12px" class="tip-note">'+jbdiagNote+'</p></li>';
													        $("#jbdiagul").append(jbdiagTool);   			
														}
														$("#jbdiagul").append("</br>");
													}else{
														$.messager.popover({msg: '不存在鉴别诊断！',type:'success',timeout: 1000});
														return;
													}
													$("#myWinMenuJB").show();  
													var myWinMenuJB = $HUI.dialog("#myWinMenuJB",{
														resizable:true,
														title:'鉴别诊断',
														width:width,
														height:height,
														modal:true
													});
												}
											})
											$('#NodeMenu').menu('show', {    
												left: e.pageX+10,    
												top: e.pageY+5   
											}); 
										}, 
									onClick:function(node){
										if (node.checked){
											$(this).tree('uncheck',node.target)  
										}else{
											$(this).tree('check',node.target)  
										}
									},
									onCheck:function(node, checked){
										var SelPropertyType=""
										if (checked==true){
											if (node.checked==false){
												SelPropertyType="add"
											}
										}else{
											SelPropertyType="remove"
										}
										ifFirstLoadPropertyData=false;
										if (proSelectFlag==false){//多选模式
											if (checked){
											   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
											}
										}else{
										
												var nodes =$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getChecked');
												if(nodes.length>1){ 
													for (var i=0;i<nodes.length;i++){
														var ids=nodes[i].id;
														if (ids==node.id) {
														
															continue
														}
														var node1 = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',ids); 
														$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node1.target);
													}
											    }
										
										}
										//获取当前选中节点的所有父节点 concat
										 var parentAll = "";
										 parentAll = node.text.split("<span class='hidecls'>")[0];
										 var flag = "，";
										 var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',node.id).target); //获取选中节点的父节点
										 for (n = 0; n < 6; n++) { //可以视树的层级合理设置k
										     if (parent != null) {
										         parentAll = flag.concat(parentAll);
										         parentAll = (parent.text.split("<span class='hidecls'>")[0]).concat(parentAll);
										         var parent = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getParent', parent.target);
										     }
										 }
										 parentAll=parentAll.split("，").reverse().join("，"); //父子级倒序显示
										 if (SelPropertyType=="add"){
											SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										 else if(SelPropertyType=="remove"){
										 	SaveSelPropertyData(index,"selpro"+trId,childDesc,node.id,parentAll,SelPropertyType)
										 }
										GetSelectedPropertyStr();//gssby20180302
										InitSmartTip("","","","");
										
									},	
									onLoadSuccess:function(node, data){
										//$('.mytooltip').tooltip();
										var Roots=$(this).tree('getRoots');
										for (var j=0;j<Roots.length;j++){
											if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
										}
										
										if (TreeCheckedIdStr!=""){
											for (var m=0;m<TreeCheckedIdStr.split("&").length;m++){
												var tmpnode = $(this).tree('find', TreeCheckedIdStr.split("&")[m]);
												if (tmpnode){
													$(this).tree('check', tmpnode.target);
													$(this).tree("expandTo",tmpnode.target);
													FindSelectFlag=1;
													ifFirstLoadPropertyData=true;
												}
											}
										}
										
										for (var j=0;j<Roots.length;j++){
												if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
										}
										
										tmpTreeCheckedIdStr="";
										SaveSelPropertyData(index,"selpro"+trId,childDesc,"","","add")
										//去掉treegrid结点前面的文件及文件夹小图标
										//$("#"+childId+"_T_"+treeNode+".tree-icon,#"+childId+"_T_"+treeNode+" .tree-file").removeClass("tree-icon tree-file");
										//$("#"+childId+"_T_"+treeNode+" .tree-icon,#"+childId+"_T_"+treeNode+" .tree-folder").removeClass("tree-icon tree-folder tree-folder-open tree-folder-closed"); 
									}
								})
						}
					}
					if (FindSelectFlag==1){
						ifFirstLoadPropertyData=true;
						$("#"+DKBBCRowId+"_"+childId+"_"+showType+isTOrP+"").removeClass("tr_dispaly");
						$("#"+childId+"_Empty_CG").attr('checked',true);
					}
				})
			/*****************左侧属性快速检索列表开始*******************************************/
			//setTimeout(function(){
				var desc=$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
				PreSearchText=desc.toUpperCase();
				LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc)
			//},50)
			//
			$HUI.radio("#SearchModeA",{
			 	onCheckChange:function(){
			 		var desc=$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
			 		if ((desc!="")&&(emptyInfo!="")){
						PreSearchText=desc.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc)
					}
			 		
			 	}
			 }); 
			//属性列表检索框定义
			 $('#Form_DiagPropertySearchText').searchbox({
			   searcher : function (value, name) { // 在用户按下搜索按钮或回车键的时候调用 searcher 函数
					if (emptyInfo!=""){
						PreSearchText=value.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,value)
					}else{
						$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
					}
			   }
			})

			if(typeof(ServerObject)!="undefined"){
				if ((typeof(ServerObject.ADMNo)=="undefined")&&(typeof(ServerObject.PMINo)=="undefined")){ //插件版快速检索框无需获取焦点，以防诊断选中后无法重新选择
					$('#Form_DiagPropertySearchText').searchbox('textbox').focus();
				}
			}
			//属性列表检索框实时检索
			var flagPropertyTime=""
			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keyup').keyup(function(e){  
				if (emptyInfo!=""){
					clearTimeout(flagPropertyTime);
					flagPropertyTime=setTimeout(function(){
						var desc=$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
						PreSearchText=desc.toUpperCase();
						LoadFormPropertySearchData(DKBBCRowId,indexTemplate,desc)
					},80)
				}else{
					$("#Form_DiagPropertySearchGrid").datagrid("loadData",[])
				}
   			}); 	
 			$('#Form_DiagPropertySearchText').searchbox('textbox').bind('click',function(){ 
 				$('#Form_DiagPropertySearchText').searchbox('textbox').select()    //重新点击时 默认之前输入的值为选中状态，方便删除     
 			});
 			$('#Form_DiagPropertySearchText').searchbox('textbox').unbind('keydown').keydown(function(e){
 				//单击其他描述获取到的属性检索列表，输入检索条件enter保存到知识库其他描述-其他文本描述节点下，同时修改到补充诊断字段
 				if ((e.keyCode == 13)&&(indexTemplate.indexOf("_")>-1)&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProperty","GetDesc",indexTemplate.split("_")[1])=="其他描述")&&(tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDesc",indexTemplate.split("_")[4])=="其他文本描述")){
 						//保存到知识库其他文本描述节点下
 						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=AddDataToOtherTextPro",   
							data:{
								"proId":indexTemplate.split("_")[1],     ///rowid
								"text":$('#Form_DiagPropertySearchText').searchbox('textbox').val() 
							},  
							type:"POST",   
							success: function(data){
									  var data=eval('('+data+')'); 
									  if (data.success == 'true') {
									  } 
									  else { 
											var errorMsg ="同步知识库文本失败！"
											if (data.errorinfo) {
												errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
											}
											$.messager.alert('操作提示',errorMsg,"error");
									}			
							}  
						})
 						
 						//其他文本描述赋值
 						var Supplement=$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val()
 						if (Supplement==""){
 							Supplement=$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}else{
 							Supplement=Supplement+"，"+$('#Form_DiagPropertySearchText').searchbox('textbox').val()
 						}
 						$("#"+indexTemplate.split("_")[1]+"_T"+indexTemplate.split("_")[5]+"_"+indexTemplate.split("_")[4]+"").val(Supplement)
 						//根据SDSRowId修改补充诊断
 						var index=""
 						var trId=""
 						$(modeJsonInfo).each(function(i,item){
 							var childId=modeJsonInfo[i].catRowId; 
							var childDesc=modeJsonInfo[i].catDesc; 
							var childType=modeJsonInfo[i].catType; 
							var showType=modeJsonInfo[i].showType;  
							var treeNode=modeJsonInfo[i].treeNode; 
							var isTOrP=modeJsonInfo[i].isTOrP; 
							if (childDesc=="文本"){
								index=i
								trId=DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP;
								return;
							}
 						})
 						SaveSelPropertyData(index,"selpro"+trId,"文本","","","remove")
						SaveSelPropertyData(index,"selpro"+trId,"文本",Supplement,Supplement,"add")
 				}
 			})
 			/*****************左侧属性快速检索列表结束*******************************************/
		
		}
		//ChangePropertyShow("",indexTemplate);
		
		
	}

	//已选属性列表 右键复制按钮
	$("#CopySelPro").click(function (e) { 
		var aux=document.getElementById("Form_DiagPropertySelCopyText"); 
		aux.value=copytext; //赋值
		aux.select(); // 选择对象 
		document.execCommand("Copy"); // 执行浏览器复制命令 
	 })
	 //已选属性列表 右键删除按钮 取消勾选
	$("#DelSelPro").click(function (e) { 
		var record=$("#Form_DiagPropertySelectedGrid").datagrid("getSelected")
		var index=record.index;
		var trId=record.titleid
		var childDesc=record.title
		var id=record.id;
		var trids=record.titleid.split("selpro")[1]; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
		var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
		var childId=trids.split("_")[1]
		var showtype=trids.split("_")[2];
		var childType=trids.split("_")[3];
		var treeNode=trids.split("_")[4];
		var isTOrP=trids.split("_")[5];
		if (showtype=="T"){ //树形
			if (childDesc=="文本"){
			  	  $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").val("")
			  	  ifFirstLoadPropertyData=false;
			  	  SaveSelPropertyData(index,"selpro"+trId,childDesc,$("#SelSDSSupplement").val(),"","remove")
			}else{
				  var node = $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('find',id); 
				  $("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('uncheck',node.target);
			}
		}
		if (showtype=="C"){ //下拉框
			$("#"+childId+"_C"+isTOrP+"").combobox('setValue', "");
		}
		if (showtype=="G"){ //列表
			var rowIndex=$("#"+childId+"_G"+isTOrP).datagrid("getRowIndex",id)
			$("#"+childId+"_G"+isTOrP).datagrid("uncheckRow",rowIndex)
		}
		if (showtype=="CB"){ //单选框
			//$("#"+childId+"_"+id+"_CB"+isTOrP+"").prop('checked','');
			$HUI.radio("#"+childId+"_"+id+"_CB"+isTOrP+"").uncheck();
			//SaveSelPropertyData(index,"selpro"+trId,childDesc,id,"","remove")
		}
		if (showtype=="CG"){ //多选框
			//$("#"+childId+"_"+id+"_CG"+isTOrP+"").prop('checked','');
			$HUI.checkbox("#"+childId+"_"+id+"_CG"+isTOrP+"").uncheck();
		}
	})
	
	function SpliceSelProperty(pindex,pid,type){
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				if (type=="add"){
					if(obj.id==""){ //清除标题行
						SelPropertyArr.splice(i,1)
					}
				}else{
					if (pid==""){ //清除所有
						SelPropertyArr.splice(i,1)
					}else{
						if (pid==obj.id){ //清除当前选中
							SelPropertyArr.splice(i,1)
						}
					}
				}
			}
		}
	}
	function GetSelPropertyNum(pindex){
		var num=0;
		for(var i in SelPropertyArr){
			var obj=SelPropertyArr[i]
			if (pindex==obj.index){
				num++;	
			}
		}
		return num;
	}
	//属性列表勾选对已选列表赋值
	function SaveSelPropertyData(pindex,ptitleid,ptitle,pid,ptext,type){
		//console.log(pindex+","+ptitleid+","+ptitle+","+pid+","+ptext+","+type)
		if(type=="add")
		{
	 	 	SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":ptext,"id":pid});
	 	 	SpliceSelProperty(pindex,pid,type);
	 	 	if((GetSelPropertyNum(pindex)==0)&&(pid=="")){
	 	 		SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
	 	 	}
	 	 	
	 	 	$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
	 	 	
		}
		if(type=="remove")
		{
			SpliceSelProperty(pindex,pid,type);
			if(GetSelPropertyNum(pindex)==0){
				SelPropertyArr.push({"index":pindex,"titleid":ptitleid,"title":ptitle,"text":"","id":""});
			}
			$("#Form_DiagPropertySelectedGrid").datagrid("loadData",SelPropertyArr)
		}
		if(indexTemplate!=undefined){
			//选中已选属性列表行
			var data=$('#Form_DiagPropertySelectedGrid').datagrid('getData')
			for (var i=1; i <data.rows.length; i++) { 
	 			if (data.rows[i]['titleid']=="selpro"+indexTemplate){
					$('#Form_DiagPropertySelectedGrid').datagrid('selectRow', i); //选中对应的行
					return;
				}
	 		}
		}else{
			$('#Form_DiagPropertySelectedGrid').datagrid('clearSelections')
		}
	}

	//仅显示已选择属性功能
	function ChangePropertyShow(showtypepara,indexTemplate){
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					var unCheckedNodes = $("#"+detailId+"").tree('getChecked', 'unchecked');
					for (var k=0;k<unCheckedNodes.length;k++){
						var nodeId=unCheckedNodes[k].id;
						var node = $("#"+detailId+"").tree('find', nodeId);
						if (showtypepara=="on"){
	            			$("#"+node.target.id).css("display","none");
						}else{
	              			$("#"+node.target.id).css("display","");
						}
					}
					if (showtypepara=="on"){
						var CheckedNodes = $("#"+detailId+"").tree('getChecked');
						if (CheckedNodes.length==0){
							$("#"+trids).css("display","none");
						}else{
							$("#"+trids).css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="C"){
					var ComboData=$("#"+detailId+"").combobox('getValue');
					if (ComboData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="G"){ //列表
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getChecked');
					if (GridData==""){
						if (showtypepara=="on"){
							$("#"+trids+"").css("display","none");
						}else{
							$("#"+trids+"").css("display","");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="CB"){
					var Find=0;
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						if (!$("#"+radioId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+radioId+"").css("display","none");
								$("#"+radioId+"").next().css("display","none");
							}else{
								$("#"+radioId+"").css("display","");
								$("#"+radioId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				if (showtype=="CG"){
					var Find=0;
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						if (!$("#"+checkboxId).is(":checked")) {
							if (showtypepara=="on"){
								$("#"+checkboxId+"").css("display","none");
								$("#"+checkboxId+"").next().css("display","none");
							}else{
								$("#"+checkboxId+"").css("display","");
								$("#"+checkboxId+"").next().css("display","");
							}
						}else{
							Find=1;
						}
					}
					if (showtypepara=="on"){
						if (Find==0){
							$("#"+trids).css("display","none");
							$("#"+trids).next().css("display","none");
						}
					}else{
						$("#"+trids).css("display","table-row");
					}
				}
				
			}
		}
	}

	//获取已选属性
	function GetSelectedPropertyStr(){
		var menuItemValueMap = {};
		var SelectedPropertyStr="";
		var SelectedPropertyDesc="";
		var SelectedPropertyName="";
		var Supplement=""
		var TreeCheckedIdStr=""
		var ComboCheckedIdStr=""
		var RadioCheckedIdStr=""
		var CheckBoxCheckedIdStr=""
		var GridCheckedIdStr=""
		var $dynamic_tr=$(".dynamic_tr");
		for (var i=0;i<($dynamic_tr.length);i++){
			(function (i) {
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1];
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];
				var isTOrP=trids.split("_")[5];
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var tds=$("#"+trids+"").children();
				
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
				    if (showtype=="T"){
				    	if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
						    var oneSelectedPropertyParentAll=""
						    var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
						    for (var k=0;k<treeCheckedIds.length;k++){
							   
								var OneTreeCheckedId=treeCheckedIds[k].id;
								/*var oneTreeCheckedDesc=treeCheckedIds[k].target.innerText
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("^")[0]*/
								var oneTreeCheckedDesc=treeCheckedIds[k].text;
								oneTreeCheckedDesc=oneTreeCheckedDesc.split("<span class='hidecls'>")[0];
								if (OneTreeCheckedId!=""){
									if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
									}else{
										var OneTreeCheckedIdItem=OneTreeCheckedId
									}
									if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
									else menuItemValueMap[childId]=OneTreeCheckedIdItem
								}
							    if (TreeCheckedIdStr=="") TreeCheckedIdStr=OneTreeCheckedId
							    else TreeCheckedIdStr=TreeCheckedIdStr+"&"+OneTreeCheckedId
							}
						}
					}
					//下拉框
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						var ComboSelText=$("#"+detailId+"").combobox('getText');
						if (ComboSelId!=""){
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem
							if (ComboCheckedIdStr=="") ComboCheckedIdStr=ComboSelId
							else ComboCheckedIdStr=ComboCheckedIdStr+"&"+ComboSelId
						}
					}
					//列表
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
							    if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
						        else menuItemValueMap[childId]=GridSelIdItem
							    if (GridCheckedIdStr=="") GridCheckedIdStr=gridId
								else GridCheckedIdStr=GridCheckedIdStr+"&"+gridId
							}
						}
					}
					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var obj=$('input[name='+radioName+']:checked');
						var CheckedObj=obj[0];
						if(CheckedObj!=undefined){
							var CBSelId=CheckedObj.id.split("_")[1];
							var CBSelDesc=obj.next().text();
							if (CBSelId!=""){
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
							    else menuItemValueMap[childId]=CBSelIdItem
							    if (RadioCheckedIdStr=="") RadioCheckedIdStr=CBSelId
								else RadioCheckedIdStr=RadioCheckedIdStr+"&"+CBSelId
							}
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
								var CGSelId=CheckedObj[m].id.split("_")[1];
								var CGSelDesc=$("#"+CheckedObj[m].id+"").next().text();
								if (CGSelId!=""){
									if (childType=="S"){
										var CGSelIdItem="S"+CGSelId
									}else{
										var CGSelIdItem=CGSelId
									}
								    if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
							        else menuItemValueMap[childId]=CGSelIdItem
								    if (CheckBoxCheckedIdStr=="") CheckBoxCheckedIdStr=CGSelId
									else CheckBoxCheckedIdStr=CheckBoxCheckedIdStr+"&"+CGSelId
								}
							}
						}
					}
				}
			})(i)
		}
		
	    for ( var mv in menuItemValueMap) {
		    if (SelectedPropertyStr=="") SelectedPropertyStr=mv+":"+menuItemValueMap[mv];
		    else SelectedPropertyStr=SelectedPropertyStr+","+mv+":"+menuItemValueMap[mv];
		}
		SelPropertyData=TreeCheckedIdStr+"^"+ComboCheckedIdStr+"^"+RadioCheckedIdStr+"^"+CheckBoxCheckedIdStr+"^"+GridCheckedIdStr
		return SelectedPropertyStr;
		}
	GetParamStr=function(termid){
		if (termid==""){
			var info=$("#SelMKBRowId").val();
		}else{
			var info=termid
		}
		if (info=="") return false;
		var newPropertyStr=""
		var SelectedPropertyStr=GetSelectedPropertyStr();
		for (var k=0;k<SelectedPropertyStr.split(",").length;k++){
			if (SelectedPropertyStr.split(",")[k]=="") continue;
			if (newPropertyStr=="") newPropertyStr=info+"-"+SelectedPropertyStr.split(",")[k];
			else newPropertyStr=newPropertyStr+","+SelectedPropertyStr.split(",")[k];
		}
		if (newPropertyStr=="") newPropertyStr=info;
		return newPropertyStr
	}
	//获取属性相关信息 ；flagFrequency：属性列表勾选是否记频次标识,结构化诊断录入标识
	GetPropertyValue=function(flagFrequency){
		var menuItemValueMap = {};
		var TreeDataStr="";
		var ComboDataStr="";
		var RadioDataStr="";
		var CheckDataStr="";
		var DataStr="";
		
		var resultRequired="" //必填项未维护结果集
		var Supplement=""; //补充诊断
		var diagNote=""; //属性列表中的诊断修饰-安贞
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<$dynamic_tr.length;i++){
			(function (i) {
				var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
				var id=trids.split("_")[0]; //诊断模板属性id
				var childId=trids.split("_")[1]; //属性id
				var showtype=trids.split("_")[2];
				var childType=trids.split("_")[3];
				var treeNode=trids.split("_")[4];//起始节点的id
				var isTOrP=trids.split("_")[5];//术语属性标识
				var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
				var ifRequired=$dynamic_tr[i].lang.split("_")[1] //是否必填项 //201917
				var tds=$("#"+trids+"").children();
				for (var j=1;j<tds.length;j++){
					//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
					var detailId=""
					var details=$("#"+trids+" td").children();
					for (var k=1;k<details.length;k++){
						if (k==1){
							detailId=details[k].id
						}
					}
					if (showtype=="T"){
						if (childDesc=="文本"){
							Supplement=$("#"+detailId+"").val()
						}else{
							//获取显示方式为树类型的选择节点串
						
							//var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
							var treeCheckedIds=$("#"+childId+"_T"+isTOrP+"_"+treeNode+"").tree('getChecked');
							//alert("#"+childId+"_T"+isTOrP+"_"+treeNode+""+treeCheckedIds)
							for (var k=0;k<treeCheckedIds.length;k++){
								var OneTreeCheckedId=treeCheckedIds[k].id;
								if (treeCheckedIds[k].text.indexOf("<span class='hidecls'>")>0){
									var OneText=treeCheckedIds[k].text.split("<span class='hidecls'>")[1].split("</span>")[0];
									var Onedisplayname=OneText.split("^")[2]; //展示名
								}else{
									var OneText=treeCheckedIds[k].text
								}
								
								if ((childType=="S")||(childType=="SS")){
										var OneTreeCheckedIdItem="S"+OneTreeCheckedId
								}else{
									var OneTreeCheckedIdItem=OneTreeCheckedId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+OneTreeCheckedIdItem;
								else menuItemValueMap[childId]=OneTreeCheckedIdItem
								//alert("OneTreeCheckedIdItem:"+OneTreeCheckedIdItem)
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var OneTreeCheckedDesc=treeCheckedIds[k].text.split("<span class='hidecls'>")[0]
									/*var retNote=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosInterface","FindDiagNote",OneTreeCheckedDesc);
									if(retNote!=""){
										diagNote=OneTreeCheckedDesc
									}*///安贞
									SaveFreq(trids+"#"+OneTreeCheckedId, OneTreeCheckedDesc,"User.SDSStructDiagnosProDetail"+id)
								}
							}
							if (treeCheckedIds==""){
								if (ifRequired=="Y"){
						    		//必填项未维护结果集
						    		if (resultRequired=="") resultRequired=childDesc
						    		else resultRequired=resultRequired+","+childDesc
						    	}
						    }
						}
					}
					//下拉框
					if (showtype=="C"){
						var ComboSelId=$("#"+detailId+"").combobox('getValue');
						if ((ComboSelId!="")&(ComboSelId!=undefined)){
							
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
								var ComboSelDesc=$("#"+detailId+"").combobox('getText')
								/*var retNote=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosInterface","FindDiagNote",ComboSelDesc);
								if(retNote!=""){
									diagNote=ComboSelDesc
								}*///安贞
								SaveFreq(trids+"#"+ComboSelId, ComboSelDesc,"User.SDSStructDiagnosProDetail"+id)
							}
							if (childType=="S"){
								var ComboSelIdItem="S"+ComboSelId
							}else{
								var ComboSelIdItem=ComboSelId
							}
							if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+ComboSelIdItem;
							else menuItemValueMap[childId]=ComboSelIdItem				
						}else{
							if (ifRequired=="Y"){
						    	//必填项未维护结果集
					    		if (resultRequired=="") resultRequired=childDesc
					    		else resultRequired=resultRequired+","+childDesc		
						    }
						}
					}
					//列表
					if (showtype=="G"){
						var gridRows=$("#"+childId+"_G"+isTOrP).datagrid("getChecked");
						if (gridRows.length>0){
							for (var i=0;i<gridRows.length;i++){
								if (isTOrP=="T"){ //术语标识
									var gridId=gridRows[i].MKBTRowId;
								}else{
									if (childType=="S"){
										var gridId=gridRows[i].MKBTRowId;
									}else if(childType=="P"){
										var gridId=gridRows[i].catRowId;
									}else{
										var gridId=gridRows[i].MKBTPDRowId;
									}
								}
								if (childType=="S"){
									var GridSelIdItem="S"+gridId
								}else{
									var GridSelIdItem=gridId
								}
							    if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+GridSelIdItem;
						        else menuItemValueMap[childId]=GridSelIdItem
							}
							//属性列表点击确定保存记频次
							if (flagFrequency!=undefined){
									for (var i=0;i<gridRows.length;i++){
										if (isTOrP=="T"){ //术语标识
											var gridIdF=gridRows[i].MKBTRowId;
					                        var gridDescF=gridRows[i].MKBTDesc;
										}else{
											if (childType=="S"){
												var gridIdF=gridRows[i].MKBTRowId;
					                        	var gridDescF=gridRows[i].MKBTDesc;
											}else if(childType=="P"){
												var gridIdF=gridRows[i].catRowId;
					                        	var gridDescF=gridRows[i].catDesc;
											}else{
												var gridIdF=gridRows[i].MKBTPDRowId;
					                        	var gridDescF=gridRows[i].comDesc;
											}
										}
										/*var retNote=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosInterface","FindDiagNote",gridDescF);
										if(retNote!=""){
											diagNote=gridDescF
										}*///安贞
										SaveFreq(trids+"#"+gridIdF, gridDescF,"User.SDSStructDiagnosProDetail"+id)
									}
							}
						}else{
							if (ifRequired=="Y"){
						    	//必填项未维护结果集
					    		if (resultRequired=="") resultRequired=childDesc
					    		else resultRequired=resultRequired+","+childDesc	
						    }
						}
					}
					//单选框
					if (showtype=="CB"){
						var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
						var CheckedObj=$('input[name='+radioName+']:checked')[0];
						if(CheckedObj!=undefined){
						
							var CBSelId=CheckedObj.id.split("_")[1];
							if (CBSelId!=""){
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									var CBSelDesc=$('input[name='+radioName+']:checked').next().text()
									/*var retNote=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosInterface","FindDiagNote",CBSelDesc);
									if(retNote!=""){
										diagNote=CBSelDesc
									}*///安贞
									SaveFreq(trids+"#"+CBSelId, CBSelDesc,"User.SDSStructDiagnosProDetail"+id)
								}
								if (childType=="S"){
									var CBSelIdItem="S"+CBSelId
								}else{
									var CBSelIdItem=CBSelId
								}
								if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CBSelIdItem;
							    else menuItemValueMap[childId]=CBSelIdItem						
							    }
						}else{
							if (ifRequired=="Y"){
						    	//必填项未维护结果集
					    		if (resultRequired=="") resultRequired=childDesc
					    		else resultRequired=resultRequired+","+childDesc		
						    }
						}
					}
					//多选框
					if (showtype=="CG"){
						var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
						var CheckedObj=$('input[name='+checkboxName+']:checked');
						if (CheckedObj!=undefined){
							for (var m=0;m<CheckedObj.length;m++){
									var CGSelId=CheckedObj[m].id.split("_")[1];
									if (childType=="S"){
										var CGSelIdItem="S"+CGSelId
									}else{
										var CGSelIdItem=CGSelId
									}
								    if (menuItemValueMap[childId]) menuItemValueMap[childId]=menuItemValueMap[childId]+"*"+CGSelIdItem;
							        else menuItemValueMap[childId]=CGSelIdItem
								}
								//属性列表点击确定保存记频次
								if (flagFrequency!=undefined){
									$('input[name='+checkboxName+']:checked').each(function(n){
										var CGSelIdF=$('input[name='+checkboxName+']:checked')[n].id.split("_")[1]
										var CGSelDescF=$(this).next().text()
										/*var retNote=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosInterface","FindDiagNote",CGSelDescF);
										if(retNote!=""){
											diagNote=CGSelDescF
										}*///安贞
										SaveFreq(trids+"#"+CGSelIdF, CGSelDescF,"User.SDSStructDiagnosProDetail"+id)
									})
							}
						}else{
							if (ifRequired=="Y"){
						    	//必填项未维护结果集
					    		if (resultRequired=="") resultRequired=childDesc
					    		else resultRequired=resultRequired+","+childDesc	
						    }
						}
					}
				}
			 })(i)
		}
	
		for ( var mv in menuItemValueMap) {
		    if (DataStr=="") DataStr=mv+":"+menuItemValueMap[mv];
		    else DataStr=DataStr+","+mv+":"+menuItemValueMap[mv];
		}
		if ($("#SelMKBRowId").val()!=""){
			var DiagnosPropertyStr=$("#SelMKBRowId").val()+"#"+DataStr+"#"+Supplement+"#"+resultRequired; //+"#"+diagNote //安贞
		}else{
			var DiagnosPropertyStr="";
		}
		if (DiagnosPropertyStr=="") return "";
		return DiagnosPropertyStr;
	}
	//快速检索前台获取数据
	function DiagPropertySearch(SearchText,indexTemplate){
		var SearchMode=$("input[name='SearchMode']:checked").val() //检索模式
		if ((SearchMode==undefined)||(SearchMode=="undefined")) SearchMode=""
		CacheDiagProperty={};
		CacheDiagPropertyNote={};
		var $dynamic_tr=$(".dynamic_tr"); 
		for (var i=0;i<($dynamic_tr.length);i++){
			var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType+"_"+childType+"_"+treeNode+"_"+isTOrP
			var DKBBCRowId=trids.split("_")[0]; //诊断模板属性id
			var childId=trids.split("_")[1]
			var showtype=trids.split("_")[2];
			var childType=trids.split("_")[3];
			var treeNode=trids.split("_")[4];
			var isTOrP=trids.split("_")[5];
			var childDesc=$dynamic_tr[i].lang.split("_")[0] //模板描述 //201917
			//分词点击功能：点击诊断显示所有，点击属性加载相应的属性列表
		 	if ((indexTemplate!=undefined)&&((indexTemplate!=""))&&(indexTemplate!=DKBBCRowId)){
		 		if ((trids)!=indexTemplate){
			 		continue;
			 	}
		 	}	
			var tds=$("#"+trids+"").children();
			var PerfectMatchId="";
			var MatchNum=0;
			var PerfectMatchNum=0;
			for (var j=1;j<tds.length;j++){
				//var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
				var detailId=""
				var details=$("#"+trids+" td").children();
				for (var k=1;k<details.length;k++){
					if (k==1){
						detailId=details[k].id
					}
				}
	      		var type=detailId.split("_")[1];
				if (showtype=="T"){
					if (childDesc=="文本"){
						var TextStr = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetDocOtherTextDescStr",treeNode)
						if (TextStr!=""){
							var TextStrArr=TextStr.split("[A]");
							for (var k=0;k<TextStrArr.length;k++){
								var TextDetailId=TextStrArr[k].split("^")[0]
								var TextDetailDesc=TextStrArr[k].split("^")[1]
								if (SearchMode==""){ //模糊检索
									if (TextDetailDesc.indexOf(SearchText)>=0){
										CacheDiagProperty[trids+"#"+TextDetailId]=TextDetailDesc; //cache
									}
								}
								if (SearchMode=="A"){ //全匹配检索
									if (TextDetailDesc==SearchText){
										CacheDiagProperty[trids+"#"+TextDetailId]=TextDetailDesc; //cache
									}
								}
							}
						}
					}else{
						$("#"+detailId+"").tree("search",trids+"^"+SearchText+"^"+SearchMode)
						//检索码>展示名>分型描述>别名 【模糊查找】  查找优先级
						//var treeData=$("#"+detailId+"").tree("options").data;
					}
				}
				if (showtype=="C"){
					//下拉框
					var ComboData=$("#"+detailId+"").combobox('getData');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTPDRowId;
							var ComboText=ComboData[k].comDesc; //TKBTDDesc
		          			var ComboPYText=ComboData[k].PYDesc.toUpperCase(); //20180315bygss
							var ComboRemark=ComboData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if (SearchMode==""){ //模糊检索
									if ((ComboText.indexOf(SearchText)>=0)||(ComboPYText.indexOf(SearchText)>=0)){
										//鼠标悬浮显示备注
	//									if (ComboRemark!=""){
	//										CacheDiagProperty[trids+"#"+ComboId]='<span class="hisui-tooltip" title="'+ComboRemark+'">'+ComboText+'</span>'//ComboText; //cache
	//									}else{
	//										CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
	//									}
										CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
										if (ComboRemark!=""){
											CacheDiagPropertyNote[trids+"#"+ComboId]=ComboRemark; 
										}
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchMode=="A"){ //全匹配检索
									if ((ComboText==SearchText)||(ComboPYText==SearchText)){
										CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
										if (ComboRemark!=""){
											CacheDiagPropertyNote[trids+"#"+ComboId]=ComboRemark; 
										}
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{//检索条件为空
								CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
								if (ComboRemark!=""){
									CacheDiagPropertyNote[trids+"#"+ComboId]=ComboRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<ComboData.length;k++){
							var ComboId=ComboData[k].MKBTRowId ;
							var ComboText=ComboData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (SearchMode==""){ //模糊检索
									if (ComboText.indexOf(SearchText)>=0){
										CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchMode=="A"){ //全匹配检索
									if (ComboText==SearchText){
										CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchText==ComboText){
									PerfectMatchId=ComboId;
								}
							}else{
								CacheDiagProperty[trids+"#"+ComboId]=ComboText; //cache
							}
						}
					}
				}
				//列表
				if (showtype=="G"){
					var GridData=$("#"+childId+"_G"+isTOrP).datagrid('getRows');
					if ((isTOrP=="P")&(childType=="L")){
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTPDRowId;
							var GridText=GridData[k].comDesc; //TKBTDDesc
		          			var GridPYText=GridData[k].PYDesc.toUpperCase(); //20180315bygss
							var GridRemark=GridData[k].MKBTPDRemark; 
							if (SearchText!=""){
								if (SearchMode==""){ //模糊检索
									if ((GridText.indexOf(SearchText)>=0)||(GridPYText.indexOf(SearchText)>=0)){
										CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
										if (GridRemark!=""){
											CacheDiagPropertyNote[trids+"#"+GridId]=GridRemark; 
										}
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchMode=="A"){ //全匹配检索
									if ((GridText==SearchText)||(GridPYText==SearchText)){
										CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
										if (GridRemark!=""){
											CacheDiagPropertyNote[trids+"#"+GridId]=GridRemark; 
										}
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{//检索条件为空
								CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
								if (GridRemark!=""){
									CacheDiagPropertyNote[trids+"#"+GridId]=GridRemark; 
								}
							}
						}
					}else{
						for (var k=0;k<GridData.length;k++){
							var GridId=GridData[k].MKBTRowId ;
							var GridText=GridData[k].MKBTDesc; //TKBTDDesc
							if (SearchText!=""){
								if (SearchMode==""){ //模糊检索
									if (GridText.indexOf(SearchText)>=0){
										CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchMode=="A"){ //全匹配检索
									if (GridText==SearchText){
										CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
										PerfectMatchNum=PerfectMatchNum+1;
									}
								}
								if (SearchText==GridText){
									PerfectMatchId=GridId;
								}
							}else{
								CacheDiagProperty[trids+"#"+GridId]=GridText; //cache
							}
						}
					}
				}
				//单选框
				if (showtype=="CB"){
					var radioName=detailId.split("_")[0]+"_"+(i)+"_CB"+isTOrP;
					var radioData=$('input[name='+radioName+']');
					for (var k=0;k<radioData.length;k++){
						var radioId=radioData[k].id;
						var radioText=$("#"+radioId+"").next()[0].innerText;
						if (SearchText!=""){
							if (SearchMode==""){ //模糊检索
								if (radioText.indexOf(SearchText)>=0){
									CacheDiagProperty[trids+"#"+radioId.split("_")[1]]=radioText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}else{
									/*$("#"+radioId+"").css("display","none");
									$("#"+radioId+"").next().css("display","none");*/
								}
							}
							if (SearchMode=="A"){ //全匹配检索
								if (radioText==SearchText){
									CacheDiagProperty[trids+"#"+radioId.split("_")[1]]=radioText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
							}
							if (SearchText==radioText){
								PerfectMatchId=radioId;
							}
							/*if (PerfectMatchId!=""){
								$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									$("#"+trids+"").css("display","none");
								}
							}*/
						}else{//检索条件为空
							CacheDiagProperty[trids+"#"+radioId.split("_")[1]]=radioText; //cache
							/*$("#"+radioId+"").css("display","");
						    $("#"+radioId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
				//多选框
				if (showtype=="CG"){
					var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG"+isTOrP;
					var checkboxData=$('input[name='+checkboxName+']');
					for (var k=0;k<checkboxData.length;k++){
						var checkboxId=checkboxData[k].id;
						var checkboxText=$("#"+checkboxId+"").next()[0].innerText;
						if (SearchText!=""){
							if (SearchMode==""){ //模糊检索
								if (checkboxText.indexOf(SearchText)>=0){
									CacheDiagProperty[trids+"#"+checkboxId.split("_")[1]]=checkboxText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}else{
									/*$("#"+checkboxId+"").css("display","none");
									$("#"+checkboxId+"").next().css("display","none");*/
								}
							}
							if (SearchMode=="A"){ //全匹配检索
								if (checkboxText==SearchText){
									CacheDiagProperty[trids+"#"+checkboxId.split("_")[1]]=checkboxText; //cache
									PerfectMatchNum=PerfectMatchNum+1;
								}
							}
							if (SearchText==checkboxText){
								PerfectMatchId=checkboxId;
							}
							if (PerfectMatchId!=""){
								//$("#"+PerfectMatchId+"").attr('checked', true);
							}else{
								if (PerfectMatchNum==0){
									//$("#"+trids+"").css("display","none");
								}
							}
						}else{//检索条件为空
							CacheDiagProperty[trids+"#"+checkboxId.split("_")[1]]=checkboxText;
							/*$("#"+checkboxId+"").css("display","");
						    $("#"+checkboxId+"").next().css("display","");
						    $("#"+trids+"").css("display","");*/
						}
					}
				}
			}
		}
		if (SearchText==""){
			//$("tr[id*='_']").css("display","table-row");
		}else{
			//$("tr[id*='_']").css("display","none");
		}
		/*if(sum==$dynamic_tr.length){
			return true
		}else{
			return false
		}*/
	}
	
/** 
 * 1）扩展jquery hisui tree的节点检索方法。使用方法如下： 
 * $("#treeId").tree("search", searchText);   
 * 其中，treeId为hisui tree的根UL元素的ID，searchText为检索的文本。 
 * 如果searchText为空或""，将恢复展示所有节点为正常状态 
 */ 
	$.extend($.fn.tree.methods, {  
        /** 
         * 扩展hisui tree的搜索方法 
         * @param tree hisui tree的根DOM节点(UL节点)的jQuery对象 
         * @param searchText 检索的文本 
         * @param this-context hisui tree的tree对象  trids+"^"+SearchText
         */  
        search: function(jqTree, str) {
	        var trids=str.split("^")[0];
	        var searchText=str.split("^")[1];
	        var searchMode = str.split("^")[2]
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
            //获取所有的树节点  
            var nodeList = getAllNodes(jqTree, tree);  
            //如果没有搜索条件，则展示所有树节点  
            searchText = $.trim(searchText);  
            /*if (searchText == "") {  
                for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).show(); 
                    tree.collapse(jqTree, nodeList[i].target); 
                }  
                //展开已选择的节点（如果之前选择了）  
                var selectedNode = tree.getChecked(jqTree);  
                if (selectedNode) { 
                	for (var i=0;i<selectedNode.length;i++){
	                	 tree.expandTo(jqTree, selectedNode[i].target);  //
	                }
                }
                return;  
            } **/
            //搜索匹配的节点并高亮显示  
            var matchedNodeList = [];  
            if (nodeList && nodeList.length>0) {  
                var node = null;  
                for (var i=0; i<nodeList.length; i++) {  
                    node = nodeList[i];  
                    
                   	if(searchText!=""){
	                    if (isMatch(searchText, node.text, searchMode)) {  
	                        //matchedNodeList.push(node);  
	                        var text=node.text.split("<span class='hidecls'>")[0];
	                    	//20180317bygss 鼠标悬浮显示备注
	                        var remark=node.text.split("^")[3].split("</span>")[0]
	                        /*if (remark!=""){
	                        	CacheDiagProperty[trids+"#"+node["id"]]='<span class="hisui-tooltip" title="'+remark+'">'+text+'</span>' //text; //cache
	                        }else{
	                        	CacheDiagProperty[trids+"#"+node["id"]]=text; //cache
	                        }*/
	                        CacheDiagProperty[trids+"#"+node["id"]]=text; //cache
	                        if (remark!=""){
	                        	CacheDiagPropertyNote[trids+"#"+node["id"]]=remark; //cache
	                        }
	                    } 
                   	}else{//检索条件为空
                   		var text=node.text.split("<span class='hidecls'>")[0];
                        var remark=node.text.split("^")[3].split("</span>")[0]
                        CacheDiagProperty[trids+"#"+node["id"]]=text; //cache
                        if (remark!=""){
                        	CacheDiagPropertyNote[trids+"#"+node["id"]]=remark; //cache
                        }
                   	}
                }  
                  
                //隐藏所有节点  
                /*for (var i=0; i<nodeList.length; i++) {  
                    $(".tree-node-targeted", nodeList[i].target).removeClass("tree-node-targeted");  
                    $(nodeList[i].target).hide();  
                }             
                //折叠所有节点  
                tree.collapseAll(jqTree);  
                //展示所有匹配的节点以及父节点              
                for (var i=0; i<matchedNodeList.length; i++) {  
                    showMatchedNode(jqTree, tree, matchedNodeList[i]);  
                } */ 
            }      
        },  
        /** 
         * 展示节点的子节点（子节点有可能在搜索的过程中被隐藏了） 
         * @param node hisui tree节点 
         */  
        showChildren: function(jqTree, node) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
              
            //展示子节点  
            if (!tree.isLeaf(jqTree, node.target)) {  
                var children = tree.getChildren(jqTree, node.target);  
                if (children && children.length>0) {  
                    for (var i=0; i<children.length; i++) {  
                        if ($(children[i].target).is(":hidden")) {  
                            $(children[i].target).show();  
                        }  
                    }  
                }  
            }     
        },
        /** 
         * 将滚动条滚动到指定的节点位置，使该节点可见（如果有滚动条才滚动，没有滚动条就不滚动） 
         * @param param { 
         *    treeContainer: hisui tree的容器（即存在滚动条的树容器）。如果为null，则取hisui tree的根UL节点的父节点。 
         *    targetNode:  将要滚动到的hisui tree节点。如果targetNode为空，则默认滚动到当前已选中的节点，如果没有选中的节点，则不滚动 
         * }  
         */  
        scrollTo: function(jqTree, param) {  
            //hisui tree的tree对象。可以通过tree.methodName(jqTree)方式调用hisui tree的方法  
            var tree = this;  
            //如果node为空，则获取当前选中的node  
            var targetNode = param && param.targetNode ? param.targetNode : tree.getSelected(jqTree);
            if (targetNode != null) {  
                //判断节点是否在可视区域                 
                var root = tree.getRoot(jqTree);  
                var $targetNode = $(targetNode.target);  
                var container = param && param.treeContainer ? param.treeContainer : jqTree.parent();  
                var containerH = container.height();  
                var nodeOffsetHeight = $targetNode.offset().top - container.offset().top;  
                if (nodeOffsetHeight > (containerH - 30)) {  
                    var scrollHeight = container.scrollTop() + nodeOffsetHeight - containerH + 30;  
                    container.scrollTop(scrollHeight);  
                }                             
            } 
        } 
    });  
    /** 
     * 展示搜索匹配的节点 
     */  
    function showMatchedNode(jqTree, tree, node) {  
        //展示所有父节点  
        $(node.target).show();  
        //return false;
        $(".tree-title", node.target).addClass("tree-node-targeted");  
        var pNode = node;  
        while ((pNode = tree.getParent(jqTree, pNode.target))) {  
            $(pNode.target).show();               
        }  
        //展开到该节点  
        tree.expandTo(jqTree, node.target);  
        //如果是非叶子节点，需折叠该节点的所有子节点  
        if (!tree.isLeaf(jqTree, node.target)) {  
            tree.collapse(jqTree, node.target);  
        }  
    }      
    /** 
     * 判断searchText是否与targetText匹配 
     * @param searchText 检索的文本 
     * @param targetText 目标文本 
     * @return true-检索的文本与目标文本匹配；否则为false. 
     */  
    function isMatch(searchText, targetText, searchMode) {
	    searchText=searchText.toUpperCase() ;
    	var text=targetText.split("<span class='hidecls'>")[0];
    	var text2=targetText.split("<span class='hidecls'>")[1];
    	var searchCode="",othername="",displayname="",aliasflag=0
    	if (text2!=""){
	    	var tmpsearchtext=text2.split("</span>")[0];
			searchCode=tmpsearchtext.split("^")[1]; //检索码
			othername=tmpsearchtext.split("^")[0]; //别名
			displayname=tmpsearchtext.split("^")[2]; //展示名
			aliasflag=1
		}
		if (searchMode==""){ //模糊匹配检索
			if(aliasflag==1){
				return ($.trim(text)!="") && ((text.toUpperCase().indexOf(searchText)!=-1) || (searchCode.toUpperCase().indexOf(searchText)!=-1) || (othername.toUpperCase().indexOf(searchText)!=-1) || (displayname.toUpperCase().indexOf(searchText)!=-1))  
		    }else{
			    return ($.trim(text)!="") && (text.toUpperCase().indexOf(searchText)!=-1);  
			}
		}
		if (searchMode=="A"){ //全匹配检索
			if(aliasflag==1){
				return ($.trim(text)!="") && ((text.toUpperCase()==searchText) || (searchCode.toUpperCase()==searchText) ||(othername.toUpperCase()==searchText) || (displayname.toUpperCase()==searchText))  
		    }else{
			    return ($.trim(text)!="") && (text.toUpperCase()==searchText);  
			}
		}
    }  
    /** 
     * 获取hisui tree的所有node节点 
     */  
    function getAllNodes(jqTree, tree) {  
        var allNodeList = jqTree.data("allNodeList"); 
        if (!allNodeList) {  
            var roots = tree.getRoots(jqTree);  
            allNodeList = getChildNodeList(jqTree, tree, roots);  
            jqTree.data("allNodeList", allNodeList);  
        }  
        return allNodeList;  
    } 
    /** 
     * 定义获取hisui tree的子节点的递归算法 
     */  
    function getChildNodeList(jqTree, tree, nodes) {  
        var childNodeList = [];  
        if (nodes && nodes.length>0) {             
            var node = null;  
            for (var i=0; i<nodes.length; i++) {  
                node = nodes[i];  
                childNodeList.push(node);  
                if (!tree.isLeaf(jqTree, node.target)) {  
                    var children = tree.getChildren(jqTree, node.target);  
                    childNodeList = childNodeList.concat(getChildNodeList(jqTree, tree, children));  
                }  
            }  
        }  
        return childNodeList;  
    }  
    
    // 扩展datagrid:动态添加删除editor  
	$.extend($.fn.datagrid.methods, {  
	    addEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item.field);  
	                e.editor = item.editor;  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param.field);  
	            e.editor = param.editor;  
	        }  
	    },  
	    removeEditor : function(jq, param) {  
	        if (param instanceof Array) {  
	            $.each(param, function(index, item) {  
	                var e = $(jq).datagrid('getColumnOption', item);  
	                e.editor = {};  
	            });  
	        } else {  
	            var e = $(jq).datagrid('getColumnOption', param);  
	            e.editor = {};  
	        }  
	    }  
	});  
    
	
	/******************************属性列表功能结束**************************************************************/
	/***************************医为智能提示功能开始***************************************************************************/
	//智能提示
	RemoveSmartTip=function(){
		if ($("#assessmentul").length>0){
			$("#assessmentul").remove();
			$("#assessmentul").children().remove();
		}
		if ($("#differdiagul").length>0){
			$("#differdiagul").remove();
			$("#differdiagul").children().remove();
		}
		if ($("#synonydiagul").length>0){
			$("#synonydiagul").remove();
			$("#synonydiagul").children().remove();
		}
		if ($("#relatedicdul").length>0){
			$("#relatedicdul").remove();
			$("#relatedicdul").children().remove();
		}
		if ($("#relateddocuul").length>0){
			$("#relateddocuul").remove();
			$("#relateddocuul").children().remove();
		}
		if ($("#drgdiagul").length>0){
			$("#drgdiagul").remove();
			$("#drgdiagul").children().remove();
		}
	}
	
	InitSmartTip=function(termid,flag,linkicdinfo,value){
		//alert(termid+","+flag+","+linkicdinfo+","+value+","+flagLoadSmartTip+","+ifFirstLoadPropertyData)
		if (flagLoadSmartTip==false) return;
		//获取当前选中tab				
		var myTab = $('#myTabs').tabs('getSelected');					
		var tabIndex = $('#myTabs').tabs('getTabIndex',myTab);	
		if (tabIndex!=2) return; //辅助功能区未选中医为智能提示时，不加载
		setTimeout(function(){
			if ((ifFirstLoadPropertyData==true)&&(flag!="init")) return;
			RemoveSmartTip(); //remove放后面，修复插件版单击诊断列表时调用两次，第二次清空问题
			if ((termid!="")&&(termid!=undefined)){ //属性列表未展开
				if($("#SelSDSRowId").val()==""){ //插件版结构化诊断列表未保存诊断行
					var paramStr=termid
					if (value!=""){
						paramStr=paramStr+"-"+value
					}
				}else{
					//var paramStr=cspRunServerMethod(ServerObject.GetParamStr, $("#SelSDSRowId").val()); 
					var paramStr=tkMakeServerCall(ServerObject.GetParamStr.split("#")[0],ServerObject.GetParamStr.split("#")[1], $("#SelSDSRowId").val()); 
				}
			}else{
				var paramStr=GetParamStr("");
				if (paramStr==false){
					return;
				}
			}
			
			//推荐评估表，鉴别诊断，同义诊断，关联ICD，相关文献,DRG分组
			var assessmentStr="",differdiagStr="",synonydiagStr="",relatedicdStr="",relateddocuStr="",drgsStr=""
			//assessmentStr="1&^IPI评分&^国际预后指数(IPI)，指标 0分、1分 。年龄 ≤60 岁 >60 岁 行为状态 0或1 2,3,4 ；Ann Arbor 分期 I 或 II III 或 IV LDH 正常、高于正常、结外病变受侵部位数 <2 个部位 ≥2 个部位 ，每一预后不良因素计数为一分"
			assessmentStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetAssessment",paramStr)
			//differdiagStr="贫血待查&^鉴别诊断在西医里面，是指根据患者的主诉，与其他疾病鉴别，并排除其他疾病的可能的诊断。症状，是病人自觉有各种异常的痛苦感觉、或通过医生诊察而得知的病态改变。如头痛、眩晕等。它是机体发生疾病后的表现，是医生诊察疾病、判断疾病的客观标志"
			differdiagStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetJBZD",paramStr)
			//synonydiagStr="14626&^缺铁性贫血"
			synonydiagStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetTYZD",paramStr)
			//relatedicdStr="14626&^C81.001 霍奇金淋巴瘤，富淋巴细胞性" //14870
			relatedicdStr=linkicdinfo;
			//relateddocuStr="“淋巴浆细胞淋巴瘤／华氏巨球蛋白血症诊断与治疗中国专家共识(2016年版)”解读&^“淋巴浆细胞淋巴瘤／华氏巨球蛋白血症诊断与治疗中国专家共识(2016年版)”解读.pdf&%《流式细胞学在非霍奇金淋巴瘤诊断中的应用专家共识（2016年版）》解读&^《流式细胞学在非霍奇金淋巴瘤诊断中的应用专家共识（2016年版）》解读.pdf"
			relateddocuStr=tkMakeServerCall("web.DHCBL.MKB.MKBKLMappingDetailInterface","GetDoc",paramStr)
			//drgsStr="RS15-淋巴瘤及非急性白血病，不伴合并症与伴随病&^权重：0.97</br>风险等级：3</br>平均住院日：7.46</br>次均费用：14497.1"
						
			//智能提示-推荐评估表生成
			if ((assessmentStr!="")&(assessmentStr!=null)){
				var assessmentTitleTool='<ul id="assessmentul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-assessment.png" style="vertical-align:middle;"><span class="tip-type"><b>推荐评估表</b></span></div></ul>'
				$("#smarttip").append(assessmentTitleTool);
				var assessment=assessmentStr.split("&%")
				for (var i=0;i<assessment.length;i++){
					//var id=i+1;
					var assessmentId=assessment[i].split("&^")[0];
					var assessmentDesc=assessment[i].split("&^")[1];
					var id=assessmentId;
					//var assessmentNote=assessment[i].split("&^")[2];
					//var assessmentTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="Assess1" class="tip-title" href="#">'+assessmentDesc+'</a></div><p class="tip-note">'+assessmentNote+'</p><span style="display:none" id="SDSAScore1"></span><span style="display:none" id="SDSADesc1"></span><span style="display:none" id="SDSARank1"></span><span style="display:none" id="SDSAValue1"></span></li>';
					var assessmentTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="Assess'+id+'" class="tip-title" href="#" onclick="viewAssessment('+id+","+assessmentId+')">'+assessmentDesc+'</a></div><p class="tip-note" style="display:none" id="PTSDSAScore'+id+'">总分：<span id="SDSAScore'+id+'"></span></p><p class="tip-note" style="display:none" id="PTSDSARank'+id+'">风险评估：<span id="SDSARank'+id+'"></span></p><p class="tip-note" style="display:none" id="PTSDSADesc'+id+'">结论：<span id="SDSADesc'+id+'"></span></p><span style="display:none" id="SDSAValue'+id+'"></span></li>';
					$("#assessmentul").append(assessmentTool);
					
					var SDSRowId=$("#SelSDSRowId").val()
					if (SDSRowId!=""){
						var assessmentInfo=tkMakeServerCall("web.DHCBL.MKB.SDSAssessment","GetInfo",SDSRowId,assessmentId); 
						if (assessmentInfo!=""){
							$("#SDSAScore"+id).text(assessmentInfo.split("&%")[0]);
							$("#SDSADesc"+id).text(assessmentInfo.split("&%")[1]);
							$("#SDSARank"+id).text(assessmentInfo.split("&%")[2]);
							$("#SDSAValue"+id).text(assessmentInfo.split("&%")[3]);
							
							$("#PTSDSAScore"+id).css("display","");
							$("#PTSDSADesc"+id).css("display","");
							$("#PTSDSARank"+id).css("display","");
						}
					}
					
				}
				$("#assessmentul").append("</br>");
			}
			//推荐评估表页面弹窗
			viewAssessment=function(id,assessmentId){
				var allvalue=tkMakeServerCall("web.DHCBL.MKB.SDSAssessment","GetValue",$("#SelSDSRowId").val(),assessmentId); 
				var repUrl="dhc.bdp.mkb.mkbassessment.csp?id="+assessmentId+"&sdflag=sd&allvalue="+allvalue+"" 
				if ("undefined"!==typeof websys_getMWToken){
					repUrl += "&MWToken="+websys_getMWToken()
				}
				$("#myWinAssessment").show();  
				var myWinAssessment = $HUI.dialog("#myWinAssessment",{
					resizable:true,
					title:'推荐评估表',
					width:$(window).width()*92/100,
					height:$(window).height()*92/100,
					modal:true,
					content:'<iframe id="Assessment" frameborder="0" src='+repUrl+' width="99%" height="98%"></iframe>',
					buttonAlign : 'center',
					buttons:[{
						text:'保存',
						handler:function(){
							if ($("#SelSDSRowId").val()==""){
								$.messager.alert("提示","请先保存诊断");
								return;	
							}
							var Score=document.getElementById('Assessment').contentWindow.document.getElementById("allscore").innerText
							var Desc=document.getElementById('Assessment').contentWindow.document.getElementById("result").innerText
							var Rank=document.getElementById('Assessment').contentWindow.document.getElementById("grade").innerText
							var Value=document.getElementById('Assessment').contentWindow.document.getElementById("allvalue").value
							if(Score==""){
								$.messager.alert("提示","请先计算总分");
								return;	
							}
							$("#SDSAScore"+id).text(Score);
							$("#SDSADesc"+id).text(Desc);
							$("#SDSARank"+id).text(Rank);
							$("#SDSAValue"+id).text(Value);
							
							$("#PTSDSAScore"+id).css("display","");
							$("#PTSDSADesc"+id).css("display","");
							$("#PTSDSARank"+id).css("display","");
							if (Score!=""){
								var info=Score+"^"+Desc+"^"+Rank+"^"+id+"^"+Value
								$.ajax({
									url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.SDSAssessment&pClassMethod=SaveAssessment",  
									data:{
										"StructRowId":$("#SelSDSRowId").val(),    
										"info":info
									},  
									type:"POST",
									success: function(data){
										  var data=eval('('+data+')'); 
										  if (data.success == 'true') {
											 		myWinAssessment.close();
											 }
											else { 
												var errorMsg ="保存失败！"
												if (data.info) {
													errorMsg =errorMsg+ '<br/>错误信息:' + data.info
												}
												$.messager.alert('操作提示',errorMsg,"error");
											}		
									}
								})
							}
						}
					},{
						text:'关闭',
						handler:function(){
							myWinAssessment.close();
						}
					}]
				});
			}
		
			//智能提示-鉴别诊断生成
			if ((differdiagStr!="")&(differdiagStr!=null)){
				var differdiagTitleTool='<ul id="differdiagul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-differdiag.png"><span class="tip-type"><b>鉴别诊断</b></span></div></ul>';
				$("#smarttip").append(differdiagTitleTool);
				var differdiag=differdiagStr.split("&%")
				for (var i=0;i<differdiag.length;i++){
					var differdiagDesc=differdiag[i].split("&^")[0];
					var differdiagNote=differdiag[i].split("&^")[1];
					var differdiagTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><span>'+differdiagDesc+'</span></div><p style="margin-left:12px" class="tip-note">'+differdiagNote+'</p></li>';
			        $("#differdiagul").append(differdiagTool);   			
				}
				$("#differdiagul").append("</br>");
			}
			//智能提示-同义诊断生成
			if ((synonydiagStr!="")&(synonydiagStr!=null)){
				var synonydiagTitleTool='<ul id="synonydiagul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-synonydiag.png"><span class="tip-type"><b>同义诊断</b></span></div></ul>'
				$("#smarttip").append(synonydiagTitleTool);
				var synonydiag=synonydiagStr.split("&%")
				for (var i=0;i<synonydiag.length;i++){
					var id=i+1;
					var synonydiagId=synonydiag[i].split("&^")[0];
					var synonydiagDesc=synonydiag[i].split("&^")[1];
					var synonydiagTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><span id="synony'+id+'" class="tip-title" href="#" >'+synonydiagDesc+'</span><span id="synonyid'+id+'" style="display:none">'+synonydiagId+'</span></div></li>';
					$("#synonydiagul").append(synonydiagTool);   
				}
				$("#synonydiagul").append("<br>"); 
			}
			//智能提示-关联ICD生成
			if ((relatedicdStr!="")&(relatedicdStr!="^")){
				//根据诊断短语获取
				var relatedicdTitleTool='<ul id="relatedicdul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-icd.png"><span class="tip-type"><b>关联ICD</b></span></div></ul>'
				$("#smarttip").append(relatedicdTitleTool);
				var relatedicdDesc=relatedicdStr.split("^")[0]+" "+relatedicdStr.split("^")[1];
				var relatedicdTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="relaticd" class="tip-title" href="#">'+relatedicdDesc+'</a></div></li>';
				$("#relatedicdul").append(relatedicdTool);   
				$("#relatedicdul").append("</br>");
				var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+paramStr+"&version="+wordVersion+"&dblflag=&DiagnosValue="
				if ("undefined"!==typeof websys_getMWToken){
					repUrl += "&MWToken="+websys_getMWToken()
				}
				//关联ICD里列表弹窗
				$("#relaticd").bind("click",function(){
					$("#myWinRelatedICD").show();  
					var myWinRelatedICD = $HUI.dialog("#myWinRelatedICD",{
						resizable:true,
						title:'关联ICD',
						width:$(window).width()*92/100,
						height:$(window).height()*92/100,
						modal:true,
						content:'<iframe id="RelatedICD" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
					});
				})
			}else{
				//根据诊断表达式获取
				$.cm({
		            ClassName:wordClassName,
		            //QueryName:"GetICD", //协和ICD
		            //QueryName:"GetICDForHIS", //安贞ICD
		            QueryName:"GetICDForCMB", //标版
		            version:wordVersion,
		            str:paramStr
		        },function(jsonData){
		        	if (jsonData.total!=0){
		        		if ($("#relatedicdul").length>0){
							$("#relatedicdul").remove();
							$("#relatedicdul").children().remove();
						}
		        		relatedicdStr=jsonData.rows[0].MRCID+"&^"+jsonData.rows[0].HISCode+" "+jsonData.rows[0].HISDesc
		        		var relatedicdTitleTool='<ul id="relatedicdul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-icd.png"><span class="tip-type"><b>关联ICD</b></span></div></ul>'
						$("#smarttip").append(relatedicdTitleTool);
						var relatedicd=relatedicdStr.split("&%")
						for (var i=0;i<relatedicd.length;i++){
							var relatedicdId=relatedicd[i].split("&^")[0];
							var relatedicdDesc=relatedicd[i].split("&^")[1];
							var relatedicdTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="relaticd" class="tip-title" href="#">'+relatedicdDesc+'</a><span id="relaticdid" style="display:none">'+relatedicdId+'</span></div></li>';
							$("#relatedicdul").append(relatedicdTool);   	
						}
						$("#relatedicdul").append("</br>");
						//关联ICD里列表弹窗
						$("#relaticd").bind("click",function(){
							var repUrl="dhc.bdp.mkb.mkbrelatedicd.csp?diag="+paramStr+"&version="+wordVersion+"&dblflag=&DiagnosValue="
							if ("undefined"!==typeof websys_getMWToken){
								repUrl += "&MWToken="+websys_getMWToken()
							}
							$("#myWinRelatedICD").show();  
							var myWinRelatedICD = $HUI.dialog("#myWinRelatedICD",{
								resizable:true,
								title:'关联ICD',
								width:$(window).width()*92/100,
								height:$(window).height()*92/100,
								modal:true,
								content:'<iframe id="RelatedICD" frameborder="0" src='+repUrl+' width="100%" height="99%"></iframe>'
							});
						})
		        	}
		        })	
			}
			//智能提示-相关文献生成
			if ((relateddocuStr!="")&(relateddocuStr!=null)){
				//var relateddocuTitleTool='<ul id="relateddocuul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-docu.png"><span class="tip-type">相关文献</span><a id="moredocu" class="tip-title" style="float:right" href="#">更多</a></div></ul>'
				var relateddocuTitleTool='<ul id="relateddocuul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-docu.png"><span class="tip-type"><b>相关文献</b></span></div></ul>'
				$("#smarttip").append(relateddocuTitleTool);
				var relateddocu=relateddocuStr.split("&%")
				for (var i=0;i<relateddocu.length;i++){
					var id=i+1;
					var relateddocuDesc=relateddocu[i].split("&^")[0];
					var relateddocuPath=relateddocu[i].split("&^")[1];
					var relateddocuTool='<li class="tip-li"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="docu'+id+'" class="tip-title" href="#" onclick="viewrelateddocu(\''+relateddocuPath+'\')">'+relateddocuDesc+'</a><span id="path'+id+'" style="display:none">'+relateddocuPath+'</span></li>';
					$("#relateddocuul").append(relateddocuTool);   	
				}
				$("#relateddocuul").append("</br>");
			}
		
			//更多相关文献列表弹窗
			/*$("#moredocu").bind("click",function(){
				var paramStr=GetParamStr();
				$("#myWinRelatedDocu").show();  
				var myWinRelatedDocu = $HUI.dialog("#myWinRelatedDocu",{
					resizable:true,
					title:'相关文献',
					modal:true,
					content:'<iframe id="RelatedDocu" frameborder="0" src="dhc.bdp.mkb.mkbrelateddocuments.csp?diag='+paramStr+'" width="99%" height="98%"></iframe>'
				});
			})*/
			
			//相关文献预览功能
		    viewrelateddocu=function(path)
		    {
				var fileType = (path).split(".")[(path).split(".").length-1];
		        var PDFisExists=tkMakeServerCall("web.DHCBL.BDP.BDPUploadFile","IsExistsFile","scripts\\bdp\\MKB\\Doc\\Doc\\"+(path).replace(fileType,"pdf"));
		        if(PDFisExists==1)
		        {
		        	fileName=path;
		        	//var filepath = "../scripts/bdp/MKB/Doc/Doc/"+fileName.replace(fileType,"pdf");
		           	var previewWin = $HUI.dialog("#myWinPreviewDocu",{
						resizable:true,
		            	modal:true,
		                title:fileName,
		                width:$(window).width()*92/100,
						height:$(window).height()*92/100
		            });
		            //$('#myWinPreviewDocu').html('<object id="PDFViewObject" type="application/pdf" width="100%" height="100%" data='+filepath+' style="display:block"> <div id="PDFNotKnown">你需要先安装pdf阅读器才能正常浏览文件，请点击<a href="http://get.adobe.com/cn/reader/download/?installer=reader_11.0_chinese_simplified_for_windows" target="_blank">这里</a>下载.</div> </object>');
		        	
		        	var filepath = "../../../Doc/Doc/"+fileName.replace(fileType,"pdf");
		            $('#myWinPreviewDocu').html('<iframe src="../scripts/bdp/MKB/MKP/pdfjs/web/viewer.html?file='+encodeURIComponent(filepath)+'"  style="height:99.2%;width:99.6%"></iframe>');
		        	//$('#myWinPreviewDocu').html('<iframe src="http://192.144.152.252/dthealth/web/scripts/bdp/MKB/MKP/pdfjs/web/viewer.html?file='+encodeURIComponent(filepath)+'"  style="height:99.2%;width:99.6%"></iframe>');
		        	$("#myWinPreviewDocu").show();   
		        }
		        else
		        {
		        	$.messager.popover({msg: '不存在pdf预览文件！',type:'success',timeout: 1000});
		        }
		    }
		    
		    
		    if ((typeof(ServerObject.ADMNo)!="undefined")&&(typeof(ServerObject.PMINo)!="undefined")){
				var mainDiag="",otherDiag=""
				var rows=$("#mygrid").datagrid("getRows")
				for(var i=0;i<rows.length;i++){
					var col=$('#layoutcenter').children().find('tr[datagrid-row-index='+i+']');
					var SDSMainDiagFlag=$(col).find('td[field=SDSMainDiagFlag] input[type=hidden]').val()
					if (rows[i].SDSRowId!=undefined){ //已保存数据
						if (rows[i].SDSIcdDesc=="") continue
						if (rows[i].RefFlag=="") continue  //已保存数据仅获取被引用诊断信息
						if (((rows[i].SDSMainDiagFlag=="Y")&&(SDSMainDiagFlag==undefined))||(SDSMainDiagFlag=="Y")){
							mainDiag=rows[i].SDSIcdDesc
						}else{
							if (otherDiag=="") otherDiag=rows[i].SDSIcdDesc
							else otherDiag=otherDiag+"^"+rows[i].SDSIcdDesc
						}
					}else{
				    	var SDSTermDR=$(col).find('td[field=SDSTermDR] input').val()
						var SDSWordDR=$(col).find('td[field=SDSWordDR] input').val()
				    	if((SDSTermDR=="")&&(SDSWordDR=="")){
				    		continue;
				    	}
				    	
				    	var SDSIcdDesc=$(col).find('td[field=SDSIcdDesc] input').val()
				    	if (SDSIcdDesc=="") continue
				    	if (SDSMainDiagFlag=="Y"){
				    		mainDiag=SDSIcdDesc
				    	}else{
				    		if (otherDiag=="") otherDiag=SDSIcdDesc
							else otherDiag=otherDiag+"^"+SDSIcdDesc
				    	}
					}
				}
				if (mainDiag==""){
					drgsStr="" //主诊断为空，不会入组，此处不调用后台，减少交互
				}else{
					drgsStr=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","GetDrgsGroup",ServerObject.ADMNo,ServerObject.PMINo,mainDiag,otherDiag)
				}
				
				//智能提示-DRG智能分组生成
				if ((drgsStr!="")&&(drgsStr!=null)){
					var drgdiagTitleTool='<ul id="drgdiagul" class="tip-ul"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-differdiag.png"><span class="tip-type"><b>DRG智能分组</b></span></div></ul>';
					$("#smarttip").append(drgdiagTitleTool);
					var drgdiagCode=drgsStr.split("&^")[0]; //drg代码
					var drgdiagDesc=drgsStr.split("&^")[1]; //drg描述
					var drgdiagWeight=drgsStr.split("&^")[2]; //权重
					var drgdiagRiskLevel=drgsStr.split("&^")[3]; //风险级别
					var drgdiagAvgHosp=drgsStr.split("&^")[4]; //平均住院日
					var drgdiagAvgCost=drgsStr.split("&^")[5]; //例均费用
					var drgdiagNote="病组权重："+drgdiagWeight+"</br>风险级别："+drgdiagRiskLevel+"</br>平均住院日："+drgdiagAvgHosp+"</br>次均费用："+drgdiagAvgCost
					var drgdiagTool='<li class="tip-li"><div class="tip-mid"><img src="../scripts/bdp/Framework/icons/mkb/sds-rightarrow.png"><a id="drgdiaggroup" class="tip-title" href="#">'+drgdiagCode+"-"+drgdiagDesc+'</a></div><p style="margin-left:12px" class="tip-note">'+drgdiagNote+'</p></li>';
			        $("#drgdiagul").append(drgdiagTool);   			
					
				    $("#drgdiagul").append("</br>");
				    
				    //诊断相关组里列表弹窗
					$("#drgdiaggroup").bind("click",function(){
						$("#myWinRelatedGroup").show();  
						var param=tkMakeServerCall("web.DHCBL.MKB.SDSDiagnosInterface","GetDrgsParam",ServerObject.ADMNo,ServerObject.PMINo,mainDiag,otherDiag)
						//var url="http://58.56.200.232:8082/drg/pages/groupfordoctor/drgResultShow.jsp?ParamJson="+encodeURI(param) //泰安服务器
						var repUrl="http://drg.mediwaydrg.com:9090/drg/pages/groupfordoctor/drgResultShow.jsp?ParamJson="+encodeURI(param) //腾讯服务器
						if ("undefined"!==typeof websys_getMWToken){
							repUrl += "&MWToken="+websys_getMWToken()
						}
						var myWinRelatedGroup = $HUI.dialog("#myWinRelatedGroup",{
							resizable:true,
							title:'诊断相关组',
							width:$(window).width()*60/100,
							height:$(window).height()*80/100,
							modal:true,
							//content:'<iframe id="RelatedGroup" frameborder="0" src="dhc.bdp.mkb.mkbrelatedgroup.csp?drgCode='+drgdiagCode+'" width="99%" height="98%"></iframe>'
							content:'<iframe id="RelatedGroup" frameborder="0" src="'+repUrl+'" width="99%" height="98%"></iframe>'
						});
					})
				}
			}
			
		},50)
	}
	
	
	/***************************医为智能提示功能结束***************************************************************************/

	
}
$(init);
