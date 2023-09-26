
var dosearch = function(start,limit,year,type,period) {
	//alert(limit);
	var pattern=/^\d{4}$/;
	if (year=="" || type=="" || period=="" ){
		year=yearField2.getValue();
		
	
		type = periodTypeField2.getValue();
		period = periodField2.getValue();
	}
	
	dept = DeptField.getValue();
	scheme=SchemeField.getValue();
	checkdr=LocResultdetailcheckDr.getValue();
	warddr=LocResultMainwardDr.getValue();
	
	if(pattern.test(year)==false){
			Ext.Msg.show({title:'注意',msg:'年份格式请输入四位有效数字!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return null;
	}else if(period==""){
		Ext.Msg.show({title:'注意',msg:'请选择查询期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
	}else{
	
	
		var urlStr = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=listNew&year='+year+'&type='+type+'&period='+period+'&dept='+dept+'&warddr='+warddr+'&checkdr='+checkdr+'&scheme='+scheme+'&userid='+userid+'&start='+start+'&limit='+limit;
		var urlStrCheck = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=GetChecks&year='+year+'&type='+type+'&period='+period+'&dept='+dept+'&warddr='+warddr+'&checkdr='+checkdr+'&scheme='+scheme+'&userid='+userid+'&start='+start+'&limit='+limit;
		Ext.Ajax.request({
			url : urlStrCheck,
			success : function(response, opts) {
			//	console.log("开始----"+Date.parse(new Date()));

				var obj=response.responseText;
				
				
				getColumnObj(obj,urlStr);
			//	console.log("结束----"+Date.parse(new Date()));

			},
			failure : function(response, opts) {
				console.log('server-side failure with status code '	+ response.status);
			}
			
		});
	}
}

//===========================固定列设置================================//
function getColumnObj(obj,urlStr){
//	console.log(jsonData);

	/*
		*如何处理json数据
		*1.获取checks中"^"拆分的数组的长度，用来存放检查点的数目
		*2.用for循环来设置添加column和映射数据的filed
		*head用check中的name，filed用check_checkRowid
		*3.数据出来完啦，再加载数据
	*/
	
	var columnArry = [
					{header:'parref',dataIndex:'parref',hidden:true},
					{header:'行号',width:35,dataIndex:'rowNum',id:'rowNum'},
					{header:'检查项',dataIndex:'schemename',sortable: true,width:150,renderer:function(value,meta,record){
							meta.attr = 'style="white-space:normal;width:150px;"';   
							return value; 
						}
					},
					{header:'科室',dataIndex:'desc',sortable: true},
					{header:'病区',dataIndex:'warddr',sortable: true,renderer:function(value,meta,record){
							meta.attr = 'style="white-space:normal;"';   
							return value; 
						}},
					{header:'期间',dataIndex:'period',sortable: true,width:70,align:'center'},
					{header:'患者编码',dataIndex:'pcode',sortable: true,width:70},
					{header:'患者姓名',dataIndex:'pname',sortable: true,width:70},
					{header:'主治医师',dataIndex:'indocname',sortable: true,width:70},
					{header:'手术医师',dataIndex:'operdocname',sortable: true,width:70},
					{header:'审核状态',dataIndex:'auditstate',sortable: true,width:70},
					{header:'审核人',dataIndex:'audituser',sortable: true,width:70 ,
						 renderer:function(value,meta,record){
							
								  meta.attr = 'style="white-space:normal;"'; 
							
							return value; 
						}},
					{header:'审核时间',dataIndex:'auditdate',sortable: true,width:80},
					{header:'发生时间',dataIndex:'occurDate',sortable: true,width:80}];//2016-9-20 add 发生时间
	var fieldArry=[
					{name: 'parref',mapping:'parref'},  
					{name: 'rowNum', mapping: 'rowNum'},					
				    {name: 'schemename', mapping: 'schemename'},
				    {name: 'desc',mapping:'desc'},
				    {name: 'warddr',mapping:'warddr'},
				    {name: 'period',mapping:'period'},
				    {name: 'pcode',mapping:'pcode'},
				    {name: 'pname',mapping:'pname'},
				    {name: 'indocname',mapping:'indocname'},
				    {name: 'operdocname',mapping:'operdocname'},
				    {name: 'auditstate',mapping:'auditstate'},
				    {name: 'audituser',mapping:'audituser'}, 
				    {name: 'auditdate',mapping:'auditdate'},
				    {name: 'occurDate',mapping:'occurDate'} ]; //2016-9-20 add 发生时间
	//===================================================================//
	//===========================处理检查点==============================//
	//var checks = obj.checks;
	var checks = obj;
	var checksArray = checks.split("^");
	var checkLen = checksArray.length;//检查点个数
	
	for(var i=1;i< checkLen;i++){
		var check =checksArray[i].split("||");
		var checkname = check[1];
		var checkindex = check[0];
		
		columnArry.push({header:checkname,dataIndex:checkindex,name:checkindex  ,
						 renderer:function(value,meta,record){
							
								  meta.attr = 'style="white-space:normal;"'; 
							
							return value; 
						}
		});
		fieldArry.push({name: checkindex,mapping:checkindex});
	
	}
	//===============================================================//
				
	var fieldsStr = Ext.data.Record.create(fieldArry);
	
	var itemGridCm = new Ext.grid.ColumnModel(
		//new Ext.grid.RowNumberer(),
		columnArry
	);
	//装载数据
	
	var itemGridDs = new Ext.data.Store({
	 //autoLoad: true,
		proxy: new Ext.data.HttpProxy({url:urlStr}),
		reader: new Ext.data.JsonReader({
			totalProperty:'totalCount',
			root:'rows'
		},fieldsStr)
	
	});
	
	itemGrid.reconfigure(itemGridDs, itemGridCm);
	itemGridDs.load({ params:{ start:0, limit:limit} });
	pageBar.bind(itemGridDs);
	
	//=========	当点击排序的时候，数据改变，但没有重新load的情况下，显示数据======================================//
	itemGridDs.on("datachanged",function (a) { 
		
		//console.log("datachanged开始----"+Date.parse(new Date()));
		
		var aLength=a.data.length;
		var colCount = itemGrid.getColumnModel().getColumnCount();//得到列数
		var divClass, columnObj, columnLen , $addWidth;
		var colName,colNullCount;
		var $columnObj,$colParent,colValue,isEm;
		var splitValue, showValue,delRowid;
		for(var j=13;j<colCount;j++){ //因为第一列不显示，所以从1开始
			 divClass="x-grid3-cell-inner x-grid3-col-"+j;
			 columnObj=$("div[class='"+divClass+"']");
			 if(j==13){ //只取一次
				  columnLen = columnObj.length;
			  }
			
			 $addWidth=$("td.x-grid3-cell.x-grid3-td-"+j);
			 colName=$addWidth.text();
			 colNullCount=0;
			
			$.each(columnObj,function(i,kObj){
				 $columnObj=$(kObj);
				 $colParent=$columnObj.parent();
				
				 colValue=kObj.innerHTML;
				 isEm=colValue.indexOf("*")>=0;
				// var isaddStyleCheck=(colValue=='&nbsp;'||colValue=='未检查'||colValue=='')
				if(colValue=='&nbsp;'||colValue=='未检查'||colValue==''){
					colNullCount++;
					$columnObj.text("未检查");
					$colParent.addClass("nocheck");
					
				}else{
					if(isEm){
						 splitValue=colValue.split("*");
						 showValue=splitValue[0];
						 delRowid=splitValue[1];
						 //var isc=(showValue==""&& rowidValue=="");
						 var isc=(showValue=="");
						 var isBlank=(showValue=="空");
						if(isBlank){
							$columnObj.text("未评价");
							$colParent.addClass("norate");
						}else if(isc){
						
							$columnObj.text("未检查");
							$colParent.addClass("nocheck");
						}else{
							$columnObj.html(showValue);
						}
						$columnObj.attr("delRowid",delRowid);
					}else{
						return false;
					}
				}
				
				
				//===========加宽备注和描述列=============/
			
				var isbz=colName.indexOf("备注")>=0;
				//var iswt=colName.indexOf("问题");	
				var isms=colName.indexOf("描述")>=0;
				var isyj=colName.indexOf("意见")>=0;
				var isnr=colName.indexOf("内容")>=0;
				if(isbz||isms||isyj||isnr){
					 $addWidth.css("width","200px");
				}
			});
			

			if(colNullCount==aLength){
				itemGrid.getColumnModel().setHidden(j,true);
			}else{
				itemGrid.getColumnModel().setHidden(j,false);
			}	
			
			
			
			
		}	
	
		//添加左侧数字列
		var colRowNumObj = $("div [class='x-grid3-cell-inner x-grid3-col-rowNum']");
		$.each(colRowNumObj,function(m,n){
			n.innerHTML=m+1;
		});
		//console.log("datachanged结束----"+Date.parse(new Date()));
	
		
	});
	//=========================datachanged结束========================================================
		//===========添加表头提示显示全部内容===========//
		
		var colHdObj=$("div[class^='x-grid3-hd-inner x-grid3-hd']")
		$(colHdObj).attr("style","text-align:center;");
		
		$.each(colHdObj,function(i,n){
			if(i>10){
				
				var innerTipValue=$(n).children()[0].nextSibling.data;
			
				$(n).attr("ext:qtitle","");
				$(n).attr("ext:qtip",innerTipValue);
				
			}
		});
		
		
		//====================style样式提取===处理=============================//
	
}