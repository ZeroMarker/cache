
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
			Ext.Msg.show({title:'ע��',msg:'��ݸ�ʽ��������λ��Ч����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
			return null;
	}else if(period==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ���ѯ�ڼ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
	}else{
	
	
		var urlStr = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=listNew&year='+year+'&type='+type+'&period='+period+'&dept='+dept+'&warddr='+warddr+'&checkdr='+checkdr+'&scheme='+scheme+'&userid='+userid+'&start='+start+'&limit='+limit;
		var urlStrCheck = '../csp/dhc.qm.qualityinfomanagementexe.csp?action=GetChecks&year='+year+'&type='+type+'&period='+period+'&dept='+dept+'&warddr='+warddr+'&checkdr='+checkdr+'&scheme='+scheme+'&userid='+userid+'&start='+start+'&limit='+limit;
		Ext.Ajax.request({
			url : urlStrCheck,
			success : function(response, opts) {
			//	console.log("��ʼ----"+Date.parse(new Date()));

				var obj=response.responseText;
				
				
				getColumnObj(obj,urlStr);
			//	console.log("����----"+Date.parse(new Date()));

			},
			failure : function(response, opts) {
				console.log('server-side failure with status code '	+ response.status);
			}
			
		});
	}
}

//===========================�̶�������================================//
function getColumnObj(obj,urlStr){
//	console.log(jsonData);

	/*
		*��δ���json����
		*1.��ȡchecks��"^"��ֵ�����ĳ��ȣ�������ż������Ŀ
		*2.��forѭ�����������column��ӳ�����ݵ�filed
		*head��check�е�name��filed��check_checkRowid
		*3.���ݳ����������ټ�������
	*/
	
	var columnArry = [
					{header:'parref',dataIndex:'parref',hidden:true},
					{header:'�к�',width:35,dataIndex:'rowNum',id:'rowNum'},
					{header:'�����',dataIndex:'schemename',sortable: true,width:150,renderer:function(value,meta,record){
							meta.attr = 'style="white-space:normal;width:150px;"';   
							return value; 
						}
					},
					{header:'����',dataIndex:'desc',sortable: true},
					{header:'����',dataIndex:'warddr',sortable: true,renderer:function(value,meta,record){
							meta.attr = 'style="white-space:normal;"';   
							return value; 
						}},
					{header:'�ڼ�',dataIndex:'period',sortable: true,width:70,align:'center'},
					{header:'���߱���',dataIndex:'pcode',sortable: true,width:70},
					{header:'��������',dataIndex:'pname',sortable: true,width:70},
					{header:'����ҽʦ',dataIndex:'indocname',sortable: true,width:70},
					{header:'����ҽʦ',dataIndex:'operdocname',sortable: true,width:70},
					{header:'���״̬',dataIndex:'auditstate',sortable: true,width:70},
					{header:'�����',dataIndex:'audituser',sortable: true,width:70 ,
						 renderer:function(value,meta,record){
							
								  meta.attr = 'style="white-space:normal;"'; 
							
							return value; 
						}},
					{header:'���ʱ��',dataIndex:'auditdate',sortable: true,width:80},
					{header:'����ʱ��',dataIndex:'occurDate',sortable: true,width:80}];//2016-9-20 add ����ʱ��
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
				    {name: 'occurDate',mapping:'occurDate'} ]; //2016-9-20 add ����ʱ��
	//===================================================================//
	//===========================�������==============================//
	//var checks = obj.checks;
	var checks = obj;
	var checksArray = checks.split("^");
	var checkLen = checksArray.length;//�������
	
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
	//װ������
	
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
	
	//=========	����������ʱ�����ݸı䣬��û������load������£���ʾ����======================================//
	itemGridDs.on("datachanged",function (a) { 
		
		//console.log("datachanged��ʼ----"+Date.parse(new Date()));
		
		var aLength=a.data.length;
		var colCount = itemGrid.getColumnModel().getColumnCount();//�õ�����
		var divClass, columnObj, columnLen , $addWidth;
		var colName,colNullCount;
		var $columnObj,$colParent,colValue,isEm;
		var splitValue, showValue,delRowid;
		for(var j=13;j<colCount;j++){ //��Ϊ��һ�в���ʾ�����Դ�1��ʼ
			 divClass="x-grid3-cell-inner x-grid3-col-"+j;
			 columnObj=$("div[class='"+divClass+"']");
			 if(j==13){ //ֻȡһ��
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
				// var isaddStyleCheck=(colValue=='&nbsp;'||colValue=='δ���'||colValue=='')
				if(colValue=='&nbsp;'||colValue=='δ���'||colValue==''){
					colNullCount++;
					$columnObj.text("δ���");
					$colParent.addClass("nocheck");
					
				}else{
					if(isEm){
						 splitValue=colValue.split("*");
						 showValue=splitValue[0];
						 delRowid=splitValue[1];
						 //var isc=(showValue==""&& rowidValue=="");
						 var isc=(showValue=="");
						 var isBlank=(showValue=="��");
						if(isBlank){
							$columnObj.text("δ����");
							$colParent.addClass("norate");
						}else if(isc){
						
							$columnObj.text("δ���");
							$colParent.addClass("nocheck");
						}else{
							$columnObj.html(showValue);
						}
						$columnObj.attr("delRowid",delRowid);
					}else{
						return false;
					}
				}
				
				
				//===========�ӿ�ע��������=============/
			
				var isbz=colName.indexOf("��ע")>=0;
				//var iswt=colName.indexOf("����");	
				var isms=colName.indexOf("����")>=0;
				var isyj=colName.indexOf("���")>=0;
				var isnr=colName.indexOf("����")>=0;
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
	
		//������������
		var colRowNumObj = $("div [class='x-grid3-cell-inner x-grid3-col-rowNum']");
		$.each(colRowNumObj,function(m,n){
			n.innerHTML=m+1;
		});
		//console.log("datachanged����----"+Date.parse(new Date()));
	
		
	});
	//=========================datachanged����========================================================
		//===========��ӱ�ͷ��ʾ��ʾȫ������===========//
		
		var colHdObj=$("div[class^='x-grid3-hd-inner x-grid3-hd']")
		$(colHdObj).attr("style","text-align:center;");
		
		$.each(colHdObj,function(i,n){
			if(i>10){
				
				var innerTipValue=$(n).children()[0].nextSibling.data;
			
				$(n).attr("ext:qtitle","");
				$(n).attr("ext:qtip",innerTipValue);
				
			}
		});
		
		
		//====================style��ʽ��ȡ===����=============================//
	
}