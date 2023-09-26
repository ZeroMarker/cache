/*
* ҩѧ�໤
* pengzhikun
*/
var url="dhcpha.clinical.action.csp";
var EpisodeID=""; //
var PatLoc="";  //���˿���
var PatWard="";  //���˲���
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;">ҩѧ��ע����</span>';
$(document).ready(function(){
	//���ݵ����ϸ��ʾ����panel
	$('.easyui-accordion ul li a').click(function(){
		 $('.easyui-accordion ul li a').css({"background":"#FFFFFF"});
		 $(this).css({"background":"#87CEFA"});
		 var panelTitle = $(this).text();
		 //�����˵�����ʾ��Ӧ����
		 choseMenu(panelTitle);
	});
	EpisodeID=getParam("EpisodeID"); //����adm
	pageBasicControll();
	InitPageData();
})

/**
* 1.�����ϻ������ݵ���ʾ����
* 2.ÿ������"�༭����.."����ȡ���㡢ʧȥ���㣬���ݿ���
*/
function pageBasicControll(){
	
	/*һ���໤����*/
	$('#GuideContent1').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#GuideContent1').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
	
	/*�����໤����*/
	$('#GuideContent2').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#GuideContent2').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
	
	/*�����໤����*/
	$('#GuideContent3').focus(function(){
		if($(this).text()=="�༭����.."){
			$(this).text("");
		}
	})
	$('#GuideContent3').blur(function(){
		if($(this).text().trim()==""){
			$(this).text("�༭����..");
		}
	})
		
}

function choseMenu(item){
	switch(item){
		case "һ��ҩѧ�໤":
			//��ֹ�ظ����������ʱFlag=1�����²�ִ�д�������
			if(Flag1==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"����Ժ����"��panel
				createLev1Panel();
				//����mainPanel�ɼ�
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:���Ŀ���;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
				InitPagePatObserver(EpisodeID);  //��ʼ��������������
			}
			
			break;
			
		case "����ҩѧ�໤":
			if(Flag2==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createLev2Panel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:���Ŀ���;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
				//��������
				//loadData();
				InitPagePatObserver(EpisodeID);  //��ʼ��������������
			}
			break;
			
		case "����ҩѧ�໤":
			if(Flag3==0){
				//����mainpanel�������ӽڵ�
				$("#mainPanel").children().css("display","none")
				//��̬����һ��"סԺ�ڼ仼��"��panel
				createLev3Panel();
				$('#mainPanel').css("display","block"); 
				$('#mainPanel').panel({
					title:item+"<span style='color:red;font-size:12pt;font-family:���Ŀ���;'>[��ɫ*�ű�ע��Ϊ������]</span>"
				});
				//��������
				//loadData();
				InitPagePatObserver(EpisodeID);  //��ʼ��������������
			}
			break;
			
		default:
			break;	
	}
				 	
} 

//--����"һ��ҩѧ�໤"������--//
var Flag1=0;//��ֹ�ظ��������δ������
function createLev1Panel() {
	if(Flag1==0){
		//����ʾ��ѯ������
		$("#PedDep_Level1").css("display","block");		
		Flag1=1;
		Flag2=0;
		Flag3=0;
		
		var locId = session['LOGON.CTLOCID'];  //��½���� bianshuai 2014-12-17
		var levelId ="1";    //�໤����"һ��"
		var titleScope = $('#mainTitle1');    //�໤��Χ�����
		var tableScope = $('#rangetable1');   //�໤��Χ����
		var titleMonItm= $('#monitmTitle1');  //�໤��Ŀ�����
		var tableMonItm= $('#monitmtable1');  //�໤��Χ����
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 


//--����"����ҩѧ�໤"������--//
var Flag2=0;//��ֹ�ظ��������δ������
function createLev2Panel() {
	if(Flag2==0){
		//����ʾ��ѯ������
		$("#PedDep_Level2").css("display","block");
		Flag2=1;
		Flag1=0;
		Flag3=0;
		
		var locId = session['LOGON.CTLOCID'];  //��½���� bianshuai 2014-12-17
		var levelId="2";    //�໤����"����"
		var titleScope = $('#mainTitle2');    //�໤��Χ�����
		var tableScope = $('#rangetable2');   //�໤��Χ����
		var titleMonItm= $('#monitmTitle2');  //�໤��Ŀ�����
		var tableMonItm= $('#monitmtable2');  //�໤��Χ����
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 

//--����"����ҩѧ�໤"������--//
var Flag3=0; //��ֹ�ظ��������δ������
function createLev3Panel() {
	if(Flag3==0){
		//����ʾ��ѯ������
		$("#PedDep_Level3").css("display","block");
		Flag3=1;
		Flag1=0;
		Flag2=0;
		
		var locId= session['LOGON.CTLOCID'];  //��½���� bianshuai 2014-12-17
		var levelId="3";    //�໤����"����"
		var titleScope = $('#mainTitle3');    //�໤��Χ�����
		var tableScope = $('#rangetable3');   //�໤��Χ����
		var titleMonItm= $('#monitmTitle3');  //�໤��Ŀ�����
		var tableMonItm= $('#monitmtable3');  //�໤��Χ����
		
		loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm);
		
	}
} 

/**
* ���ݿ���ID�ͼ໤���𣬶�̬��ѯ�໤��Χ����
*/
function loadLevData(locId,levelId,titleScope,tableScope,titleMonItm,tableMonItm){
	//��ȡ�໤��Χ����
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=getRangeListInfo',//�ύ������ �����ķ���  
		data: {ctloc:locId, level:levelId,rows:999,page:1}, //�ύ�Ĳ���  
		success:function(msg){ 
			createLevScope(msg,titleScope,tableScope);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); 
	
	//��ȡ�໤��Ŀ����
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=GetMonItmInfo',//�ύ������ �����ķ���  
		data: {ctloc:locId, level:levelId,rows:999,page:1}, //�ύ�Ĳ���  
		success:function(msg){ 
			createMonItm(msg,titleMonItm,tableMonItm);      
		},    
		error:function(){        
			alert("��ȡ����ʧ��!");
		}
	}); 
}

/**
* ��̬���ؼ໤��Χ�����б�
*/
function createLevScope(msg,title,table){
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	table.children().remove();  //��ɾ��table�ڵ���Ԫ�أ������ظ�����
	for(var i=0;i<arrayJson.length;i++){
		var row = $("<tr></tr>"); 
		var td = $("<td></td>"); 
		$('<input />',{name:arrayJson[i].rowid,type:'checkbox'}).appendTo(td);
		$('<span />',{
			text:"  "+arrayJson[i].desc         //���Ӽ�϶
		}).appendTo(td);
		row.append(td); 
		table.append(row);
	}
	
	//title.css('height',table.height()+"px").css("line-height",table.height()+"px");
	 	 
}

/**
* ��̬���ؼ໤��Ŀ�����б�
*/
function createMonItm(msg,title,table){
	var obj = eval( "(" + msg + ")" ); //ת�����JSON����
	var arrayJson=obj.rows;
	table.children().remove();  //��ɾ��table�ڵ���Ԫ�أ������ظ�����
	/**
	*1.��̬�������������3
	*2.��������arrayJson.length/3ȡ����Ȼ��+1
	*3.����ǰ0��arrayJson.length/3�У�ÿ�ж�̬���3��
	*4.���һ�У�����arrayJson.length%3��ģ�Ľ����̬����td�ĸ���
	*/
	for(var i=0;i<Math.floor(arrayJson.length/3)+1;i++){
		var row = $("<tr></tr>");
		if(i<Math.floor(arrayJson.length/3)){
			for(var j=0;j<3;j++){ 
				var td = $("<td></td>");
				/*
				$('<input />',{
					name:arrayJson[3*i+j].rowid,
					type:'checkbox'
				}).appendTo(td);
				
				$('<span />',{
					text:"  "+arrayJson[3*i+j].desc       //���Ӽ�϶
				}).appendTo(td);
				*/

				var tempdesc=arrayJson[3*i+j].desc.replace("[]","<input style='width:80px;' name='monItems' id="+arrayJson[3*i+j].rowid+"></input>");
				$('<span>'+tempdesc+'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>').appendTo(td);
				row.append(td);
			} 
			table.append(row);
		}else{
			for(var j=0;j<arrayJson.length%3;j++){ 
				var td = $("<td></td>");
				/*
				$('<input />',{
					name:arrayJson[3*i+j].rowid,
					type:'checkbox'
				}).appendTo(td);
				$('<span />',{
					text:"  "+arrayJson[3*i+j].desc       //���Ӽ�϶
				}).appendTo(td);
				*/
				var tempdesc=arrayJson[3*i+j].desc.replace("[]","<input style='width:80px;' name='monItems' id="+arrayJson[3*i+j].rowid+"></input>");
				$('<span>'+tempdesc+'&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>').appendTo(td);

				row.append(td);
			} 
			table.append(row);
			
		}
	}
	
	//title.css('height',table.height()+"px").css("line-height",table.height()+"px");
	 	 
}


//���ؽ����ʼdatagrid��ʾ
function InitPageData(){
	
    if(EpisodeID==""){
	    alert("δ��ȡ�����˵ľ���ţ���رմ��ڣ����²�����лл����")
	    return;
    }
    
    ///��ȡ���˻�����Ϣ 2015-03-06 bianshuai
    var patEssInfo=tkMakeServerCall("web.DHCSTPHCMCOMMON","GetPatEssInfo","",EpisodeID);
    if(patEssInfo==""){
	    alert("���ز��˻�����Ϣ����");
    	return;
    }
    var patEssInfoArr=patEssInfo.split("^");
	PatLoc=patEssInfoArr[16];  //���߿���Id
	PatWard=patEssInfoArr[18]; //���߲���Id
    
    /*   ע�� 2015-03-06 bianshuai
    //��ȡ���˻�����Ϣ
    $.ajax({
   		type: "POST",
   		url: url,
   		data: "action=getAdrRepPatInfo&AdmDr="+EpisodeID+"&LocID="+"",
   		//dataType: "json",
   		success: function(val){
			tmp=val.split("^");
			//������Ϣ
			//���߿���Id
			PatLoc=tmp[14];
			//���߲���Id
			PatWard=tmp[17];

   		}
    });
    */
	
	/*  ע�� 2015-03-16 bianshuai
	//����columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
	    {field:'incidesc',title:'��Ʒ����',width:300,align:'left'},
	    {field:'genenic',title:'ͨ����',width:300,align:'left'},
	    {field:'manf',title:'������ҵ',width:300,align:'left'},
		{field:'operation',title:'<a href="#" onclick="patOeInfoWindow()"><img style="margin-left:3px;" src="../scripts/dhcpha/jQuery/themes/icons/edit_add.png" border=0/></a>',
		    width:30,
		    align:'center',
			formatter:SetCellUrl
		}
	]];
	
	//����datagrid
	$('#drugdg1').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg1").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	//����datagrid
	$('#drugdg2').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg2").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	//����datagrid
	$('#drugdg3').datagrid({
		title:titleNotes,    
		url:'',
		border:false,
		columns:columns,
	    singleSelect:true,
	    rownumbers:true,//�к� 
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            //if (editRow != "") { 
              //  $("#susdrgdg").datagrid('endEdit', editRow); 
            //} 
            //$("#drugdg3").datagrid('beginEdit', rowIndex); 
            //editRow = rowIndex; 
        }
	});
	
	InitdatagridRow();
	*/
}

//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<4;k++)
	{
		$("#drugdg1").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
		$("#drugdg2").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
		$("#drugdg3").datagrid('insertRow',{
			index: 0, 
			row: {orditm:'',phcdf:'',incidesc:'',genenic:'',manf:''}
		});
	}
}

// ɾ����
function delRow(datagID,rowIndex)
{
	//�ж���
    var rowobj={
		orditm:'', incidesc:'', genenic:'', manf:''
	};
	
	//��ǰ��������4,��ɾ�����������
	var selItem=$('#'+datagID).datagrid('getSelected');
	var rowIndex = $('#'+datagID).datagrid('getRowIndex',selItem);
	if(rowIndex=="-1"){
		$.messager.alert("��ʾ:","����ѡ���У�");
		return;
	}
	var rows = $('#'+datagID).datagrid('getRows');
	if(rows.length>4){
		 $('#'+datagID).datagrid('deleteRow',rowIndex);
	}else{
		$('#'+datagID).datagrid('updateRow',{
			index: rowIndex, // ������
			row: rowobj
		});
	}
}

/// ����
function SetCellUrl(value, rowData, rowIndex)
{	
	var dgID='"'+rowData.dgID+'"';
	return "<a href='#' onclick='delRow("+dgID+","+rowIndex+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
}

/// ����ҩƷ����
function patOeInfoWindow()
{
	$('#mwin').window({
		title:'������ҩ�б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:1000,
		height:520
	}); 

	$('#mwin').window('open');
	InitPatMedGrid();
}

//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:'����',width:280},
		{field:'genenic',title:'ͨ����',width:160},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:'����',width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:'�÷�',width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:'Ƶ��',width:40},
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:'�Ƴ�',width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:'��׼�ĺ�',width:80},
		{field:'manf',title:'����',width:80},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:'����',width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	});
	
	$('#medInfo').datagrid({
		url:url+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
}

function addWatchDrg(){
	if(Flag1==1){
		//var phaWardRid=$('#RowId').val();
		var phaWardRid=""
		//����Ժ���߽���
		//��ҩ�б�
		var rows = $('#drugdg1').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
		
		//��ȡҽ���б���ѡ����
		var checkedItems = $('#medInfo').datagrid('getChecked');
		/**
		*1.�����ʼ�鷿��¼rowid�����ڣ���ҩƷ�б���ʾΪ��ʼ��Ŀ
		*2.����鷿��¼rowid���ڣ�����ݹ�עҩƷ����datagrid��ʾ��ͨ��reload��ʽ
		*/

		if(phaWardRid==""){
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg1'
				}
	    		if(k>3){
					$("#drugdg1").datagrid('appendRow',rowobj);
				}else{
					$("#drugdg1").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
						index: k, // ������0��ʼ����
						row: rowobj
					});
				}
				k=k+1;
    		})
    	}else{
    		$.each(checkedItems, function(index, item){
	    		var rowobj={
					orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     		manf:item.manf, dgID:'drugdg1'
				}
				$("#drugdg1").datagrid('appendRow',rowobj);
	   		});
	    }
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag2==1){
		//�鷿����
		//��ҩ�б�
		var rows = $('#drugdg2').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	manf:item.manf, dgID:'drugdg2'
			}
	    	if(k>3){
				$("#drugdg2").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg2").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
					index: k, // ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
    	})
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}else if(Flag3==1){
		//�鷿����
		//��ҩ�б�
		var rows = $('#drugdg3').datagrid('getChanges');
		var k=0;
		for(var i=0;i<rows.length;i++)
		{
			if(rows[i].orditm!=""){
				//break;
				k=k+1;
			}
		}
	
		var checkedItems = $('#medInfo').datagrid('getChecked');
    	$.each(checkedItems, function(index, item){
	    	var rowobj={
				orditm:item.orditm,  incidesc:item.incidesc, genenic:item.genenic+"/["+item.form+"]", 
		     	manf:item.manf, dgID:'drugdg3'
			}
	    	if(k>3){
				$("#drugdg3").datagrid('appendRow',rowobj);
			}else{
				$("#drugdg3").datagrid('updateRow',{	//��ָ����������ݣ�appendRow�������һ���������
					index: k, // ������0��ʼ����
					row: rowobj
				});
			}
			k=k+1;
    	})
    	$('#mwin').window('close');
    	//$('#medInfo').datagrid().clearSelections();
	}
  
}

//���˵������ı���Ϣ�пո�
String.prototype.trim=function(){
	return this.replace(/(^\s*)|(\s*$)/g,"");
}

/*���Ƽ���ı���textarea�ĳ���*/
function textCounter(field, countfield, maxlimit) {  
   // ������3�������������֣�����Ԫ�����������ַ��� 
   if (field.value.length > maxlimit){  
       //���Ԫ�����ַ�����������ַ�������������ַ����ضϣ�  
   	   field.value = field.value.substring(0, maxlimit); 
   }else{
       //�ڼ������ı�������ʾʣ����ַ�����  
       countfield.value = maxlimit - field.value.length;  
   }
}

/**
* �ύ����һ��ҩѧ�໤����
*/
function saveLevel1Info(){

	//�໤��Χ�б�
	var scopeArr=[];
	$("#rangetable1 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//�໤��Ŀ�б�	
	var monItmArr=[];
	$("#monitmtable1 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());
	});
	monItmList=monItmArr.join("||");

	//�ص��עҩ��
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg1').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//�໤����(��д������)
	var careContent=$("#GuideContent1").val();
	
	//��Ҫ������
	var Imptres=$("#Imptres1").val();
	
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="1";  //�໤����"һ��"����ӦDrΪ1 
	
	//ҩѧ�໤����Ϣ
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=SavePharCareInf',//�ύ������  
		data: "rowid="+rowid+"&"+"input="+input,//�ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
}


/**
* �ύ�������ҩѧ�໤����
*/
function saveLevel2Info(){

	//�໤��Χ�б�
	var scopeArr=[];
	$("#rangetable2 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//�໤��Ŀ�б�	
	var monItmArr=[];
	$("#monitmtable2 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());
	});
	monItmList=monItmArr.join("||");

	//�ص��עҩ��
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg2').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//�໤����(��д������)
	var careContent=$("#GuideContent2").val();
	
	//��Ҫ������
	var Imptres=$("#Imptres2").val();
	
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="2";  //�໤����"����"����ӦDrΪ2 
	
	//ҩѧ�໤����Ϣ
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=SavePharCareInf',//�ύ������  
		data: "rowid="+rowid+"&"+"input="+input,//�ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
}

/**
* �ύ��������ҩѧ�໤����
*/
function saveLevel3Info(){

	//�໤��Χ�б�
	var scopeArr=[];
	$("#rangetable3 input[type='checkbox']").each(function(){
		if ($(this).attr("checked")){
          	scopeArr.push(this.name);
		}	
	});
	scopeList=scopeArr.join("||");
	
	//�໤��Ŀ�б�	
	var monItmArr=[];
	$("#monitmtable3 input[name='monItems']").each(function(){
		monItmArr.push(this.id+"^"+$(this).val());	
	});
	monItmList=monItmArr.join("||");
	
	//�ص��עҩ��
	var tmpItmArr=[];
	/*
	var drugItems = $('#drugdg3').datagrid('getRows');
	$.each(drugItems, function(index, item){
		if(item.orditm!=""){
		    var tmp=item.orditm
		    tmpItmArr.push(tmp);
		}
	})
	*/
	//�໤����(��д������)
	var careContent=$("#GuideContent3").val();
	
	//��Ҫ������
	var Imptres=$("#Imptres3").val();
	
	//��¼��
	var UserDr=session['LOGON.USERID'];
	
	var levelDr="3";  //�໤����"һ��"����ӦDrΪ3 
	
	//ҩѧ�໤����Ϣ
	var phaCareMasDataLis=levelDr+"^"+EpisodeID+"^"+PatWard+"^"+PatLoc+"^"+UserDr+"^"+careContent+"^"+Imptres;
	
	var rowid="";
	var input=phaCareMasDataLis+"!!"+scopeList+"!!"+monItmList+"!!"+tmpItmArr;
	
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?actiontype=SavePharCareInf',//�ύ������  
		data: "rowid="+rowid+"&"+"input="+input,//�ύ�Ĳ���  
		success:function(msg){ 
			if(msg!=0){
				alert("����ʧ��,ʧ��״̬��Ϊ"+msg);
			}else{           
				alert("����ɹ�");
				clearData();
			}       
		},    
		error:function(){        
			alert("����ʧ��");        
		}
	});
}

function clearData(){
	window.location.reload();
}

/// ��ʼ�����˵��������� bianshuai 2015-03-09
function InitPagePatObserver(EpisodeID)
{
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: url+'?action=GetPatVitalSigns',//�ύ������  
		data: "EpisodeID="+EpisodeID,//�ύ�Ĳ���  
		success:function(msg){
			var obj=eval('('+msg+')');
			if(obj){
				$("input[name=monItems]").each(function(){
					var tempstr=$(this).parent().html();
					var obserdesc=tempstr.substring(0,2).replace(/(^\s*)|(\s*$)/g,"");					
					if(typeof obj[obserdesc]!="undefined"){
						$(this).val(obj[obserdesc]); //��ֵ
					}
				})
			}      
		},
		error:function(){        
			alert("ȡ����������������");        
		}
	});
}