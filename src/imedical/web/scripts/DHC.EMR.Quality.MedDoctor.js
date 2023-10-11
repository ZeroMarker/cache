$(function(){
	initcombox()
	
	initRangeBox()
	initGradeBox()
	doSearch()
	InitAuthorityDataList()
	if(HISUIStyleCode == "lite"){
	    $(".div_center").css({'background-color':'#f5f5f5'});
	}
})

var checkType='CQC'

var GradeOBJ={
	1:emrTrans("סԺ��"),
	2:emrTrans("�����ʿ�ҽʦ"),
	3:emrTrans("�����ʿ�ҽʦ"),
	4:emrTrans("�����ʿؼ��Ա"),
	5:emrTrans("ר����ʿ�Ա")
}

var RangeOBJ={
	IA:emrTrans("���ڲ���"),
	AO:emrTrans("���ﲡ��"),
	CQC:emrTrans("��ĩ����")
}

//���ҳ�ʼ��
function initcombox()
{
	$('#locId').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID+'&AlocID=',
		mode:'remote',
		onChange: function (n,o) {
			$('#locId').combobox('setValue',n);
		    var newText = $('#locId').combobox('getText');
			$('#locId').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetAllCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase()))+'&AlocID=';
		},
		onSelect: function(record){
			InitUserInfo(record.ID)
	    } 
    });
}

///��ʼ���û��б�
function InitUserInfo(locId){
	
	if(locId==="")
	{
		return
	}
	
	//��ȡ�û�����
	$cm({
		ClassName:"EPRservice.Quality.Ajax.SSUserInfo",
		MethodName:"GetDoctorByDFDeptId",
		locId:locId,
		filter:"",
		dataType:'text'
	},function(res){
		//չʾ�û�����	
		res=JSON.parse(res)
		$('#userInfo').combobox
		({
			valueField:"UserId",  
		    textField:"UserName",
		    panelHeight:"100",
			mode:'local',
			data:res,
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].indexOf(q) == 0;
			}
	    });	
	});
	
	
    
    
}
var userInfo={}
userInfo.userId=""
userInfo.range=""
userInfo.stDate=""
userInfo.edDate=""


function initRangeBox()
{
	//��ʼ��������Χ���������ö�ѡ�Լ�ѡ����ʽ
	$HUI.combobox("#checkRange",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		data:[
			{id:'AO',text:emrTrans('���ﲡ��')},
			{id:'IA',text:emrTrans('���ڲ���')}
			,{id:checkType,text:emrTrans('��ĩ����'),selected:true}
		],
		formatter:function(row){  
			var rhtml;
			
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
}
function initGradeBox()
{
	//��ʼ��ҽʦ�ȼ����������ö�ѡ�Լ�ѡ����ʽ
	$HUI.combobox("#Grade",{
		valueField:'id',
		textField:'text',
		multiple:true,
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:true,
		data:[
			{id:'1',text:emrTrans('סԺ��'),selected:true},
			{id:'2',text:emrTrans('�����ʿ�ҽʦ')},
			{id:'3',text:emrTrans('�����ʿ�ҽʦ')},
			{id:'4',text:emrTrans('�����������Ա')},
			{id:'5',text:emrTrans('ר����ʿ�Ա')}
		]
	});
}

function getLocInfo(){
	return $("#locId").combobox("getData")
}

var UpdateUserId=0

var dataStorage=null

var tableEdit={
	editIndex:undefined,
	data:{
		StartDate:null,
		EndDate:null,
		Grade:null,
		Range:null
	},
	currentIndex:0
}
function InitAuthorityDataList()
{
	$('#userList').datagrid({
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            //pagePosition: 'bottom',
			fitColumns: true,
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.MedDoctor.cls',  //*********
			queryParams: {
				userId:userInfo.userId,
				range:userInfo.range,
				stDate:userInfo.stDate,
				edDate:userInfo.edDate
            },
			singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				//LocDesc
				{field:'Save',title:'����',width:100,align:'left',
				formatter:function(v,r){
					return '<div id="Save" onclick="handleSave()" title="����"><span class="icon-save">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
				}},
				{field:'Delete',title:'ɾ��',width:100,align:'left',
				formatter:function(v,r){
					return "<div id='Delete' onclick='handleDelete(\""+r.UserId+"\")' title='ɾ��'><span class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span></div>"
				}},
				{field:'LocDesc',title:'����',width:100,align:'left'},
				{field:'UserName',title:'�û���',width:100,align:'left'},
				{field:'Range',title:'�ʿط�Χ',width:100,align:'left',
					formatter:function(v,r){						
						return getRangeTexts(v.split(","))
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'desc',
							panelHeight:'auto',
							multiple:true,
							onSelect:function(record){
								getRangeValue(this)
								
							},
							onShowPanel:function(){
								//$(this).combobox("setValue",[])
							},
							data: [{
								id: 'AO',
								desc: '���ﲡ��'
							},{
								id: 'IA',
								desc: '���ڲ���'
							},{
								id: 'CQC',
								desc: '��ĩ����'
							}]
							
							
						}
					}
				},
				{field:'Grade',title:'ҽʦ�ȼ�',width:100,align:'left',
					formatter:function(v,r){
						return GradeOBJ[r.Grade]
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'id',
							textField:'desc',
							panelHeight:'auto',
							data: [{
								id: '1',
								desc: 'סԺ��'
							},{
								id: '2',
								desc: '�����ʿ�ҽʦ'
							},{
								id: '3',
								desc: '�����ʿ�ҽʦ'
							},{
								id:'4',
								desc:'�����������Ա'
							},{
								id:'5',
								desc:'ר����ʿ�Ա'
							}
							
							]
							
							
						}
					}
				},
				{field:'StartDate',title:'��ʼʱ��',width:100,align:'left',
					formatter:function(v,r){
						return r.StartDate
					},
					editor:{
						type:'datebox'
					},
				},
				{field:'EndDate',title:'����ʱ��',width:100,align:'left',
					formatter:function(v,r){
						return r.EndDate
					},
					editor:{
						type:'datebox'
					},}
			]],
		  
		  onClickRow:onClickRow,
		  loadFilter:function(data)
		  {
			  if(typeof data.length == 'number' && typeof data.splice == 'function'){
				  data={total: data.length,rows: data}
			  }
    		  var dg=$(this);
    		  var opts=dg.datagrid('options');
              var pager=dg.datagrid('getPager');
              pager.pagination({
    	      	onSelectPage:function(pageNum, pageSize){
	    	      	opts.pageNumber=pageNum;
        	 	  	opts.pageSize=pageSize;
        	     	pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
        	     	dg.datagrid('loadData',data);
        	    }
              });
    		  if(!data.originalRows){
	    		  data.originalRows = (data.rows);
              }
   		 	  var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
              var end = start + parseInt(opts.pageSize);
              data.rows = (data.originalRows.slice(start, end));
              return data;
          }
	  }); 
	  $.parser.parse('#userList');
}

function handleDelete(user){
	
	$.messager.confirm("ɾ��","ȷ��ɾ������Ϣ��",function(r){
		if(r){
			deleteUserInfo(user)
		}else{
			console.log("ȡ���˲���")
		}
	})
	
	
	
}

function deleteUserInfo(user){
	
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.MedDoctor",
		MethodName:"DeleteMedDoctorInfo",
		UserId:user,
		dataType:'text'
	},function(res){
		console.log(res)
		if(res==="ɾ���ɹ�")
		{
			$.messager.alert("��ʾ:","ɾ���ɹ�","info")
			refresh()
		}else
		{
			$.messager.alert("��ʾ:","ɾ��ʧ��","error")
		}
	});
}

///���༭

function endEditing(){
			if (tableEdit.editIndex == undefined){return true}
			if ($('#userList').datagrid('validateRow', tableEdit.editIndex)){
				
				var startDate = $('#userList').datagrid('getEditor', {index:tableEdit.editIndex,field:'StartDate'});
				var StartDate = $(startDate.target).datebox('getText');
				$('#userList').datagrid('getRows')[tableEdit.editIndex]['StartDate'] = StartDate;
				tableEdit.data.StartDate=StartDate
				
				var RG = $('#userList').datagrid('getEditor', {index:tableEdit.editIndex,field:'Range'});
				var Range = $(RG.target).combobox('getText');
				var RGID = $(RG.target).combobox('getValues');
				
				$('#userList').datagrid('getRows')[tableEdit.editIndex]['Range'] = Range;
				tableEdit.data.Range=rangeFormatter(RGID)
				
				var ed = $('#userList').datagrid('getEditor', {index:tableEdit.editIndex,field:'Grade'});
				var Grade = $(ed.target).combobox('getText');
				var GradeID = $(ed.target).combobox('getValue');
				$('#userList').datagrid('getRows')[tableEdit.editIndex]['Grade'] = Grade;
				tableEdit.data.Grade=GradeID
				
				var endDate = $('#userList').datagrid('getEditor', {index:tableEdit.editIndex,field:'EndDate'});
				var EndDate = $(endDate.target).datebox('getText');
				$('#userList').datagrid('getRows')[tableEdit.editIndex]['EndDate'] = EndDate;
				tableEdit.data.EndDate=EndDate
				
				$('#userList').datagrid('endEdit', tableEdit.editIndex);
				
				tableEdit.editIndex = undefined;
				
				return true;
			} else {
				return false;
			}
		}
		
function onClickRow(index){
		UpdateUserId=$('#userList').datagrid('getRows')[index]['UserId']
		if (tableEdit.editIndex!=index) {
			if (endEditing()){
				$('#userList').datagrid('selectRow', index).datagrid('beginEdit', index);
				tableEdit.editIndex = index;
				
			} else {
				$('#userList').datagrid('selectRow', tableEdit.editIndex);
			}
		}
		
	}
	
function handleSave(){
	
	
	endEditing()
	
	doUpdate(tableEdit.data.Grade,tableEdit.data.Range,tableEdit.data.StartDate,tableEdit.data.EndDate)
	
}	         

function doUpdate(grade,range,startDate,endDate)
{
	if(!validCheck(startDate,endDate)){
		$.messager.alert("��ʾ","��ʼʱ��ӦС�ڽ���ʱ��,����!","info")
		return
	}
	if(UpdateUserId===0)
	{
		$.messager.alert("��ʾ","��˫��ѡ��Ҫ�޸ĵ���!","info")
		return
	}
	
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.MedDoctor",
		MethodName:"UpDateMedDoctorInfo",
		STDate:startDate,
		EDDate:endDate,
		Grade:grade,
		Range:range.toString(),
		OldUserId:UpdateUserId,
		dataType:'text'
	},function(res){
		
		if(res==="�޸ĳɹ�")
		{
			$.messager.alert("��ʾ","�޸ĳɹ�","info")
			refresh()
		}else
		{
			$.messager.alert("��ʾ","�޸�ʧ��","info")
		}
	});
}

function doAdd()
{
	var userId=$("#userInfo").combobox("getValue");
	
	var stDate=$("#inputCreateDateStart").datebox("getValue");
	var edDate=$("#inputCreateDateEnd").datebox("getValue");
	
	if(stDate==""||edDate==""){
		$.messager.alert("��ʾ","�����뿪ʼ�ͽ���ʱ��","info")
		return
	}
	
	//�����û��Ƿ���ά��
	CheckUser(userId)
	
	
}


function doSearch(){
	var userId=$("#userInfo").combobox("getValue");
	var stDate=$("#inputCreateDateStart").datebox("getValue");
	var edDate=$("#inputCreateDateEnd").datebox("getValue");
	var range=$("#checkRange").combobox("getValues").toString();
	var LocID=$("#locId").combobox("getValue");
	var queryParams={
		userId:userId,
		stDate:stDate,
		edDate:edDate,
		range:range,
		locInfo:LocID
	}
	$('#userList').datagrid('options').queryParams=queryParams;
	$('#userList').datagrid('reload')
	tableEdit.editIndex=undefined
}

function refresh(){
	var queryParams={
		userId:"",
		stDate:"",
		edDate:"",
		range:""
	}
	$('#userList').datagrid('options').queryParams=queryParams;
	$('#userList').datagrid('reload')
	tableEdit.editIndex=undefined
}

function setMedDocInfo(rowIndex,rowData)
{
	var range=""
	UpdateUserId=rowData.UserId  //�������µ��û�
	$("#userInfo").combobox("setValue",rowData.UserId);
	
	$("#userInfo").combobox("setText",rowData.UserName);
	
	$("#inputCreateDateStart").datebox("setValue",rowData.StartDate);
	$("#inputCreateDateEnd").datebox("setValue",rowData.EndDate);
	
	range=rowData.Range.replace("���ڲ���","IA")
	range=range.replace("���ﲡ��","AO")
	range=range.replace("��ĩ����",checkType)
	
	
	
	$("#checkRange").combobox("setValues",range.split(","));
	$("#checkRange").combobox("setText",rowData.Range);

}

function CheckUser(userId)
{
	$cm({
		ClassName:"EPRservice.Quality.DataAccess.MedDoctor",
		MethodName:"CheckUser",
		userId:userId,
		dataType:'text'
	},function(res){
		if(res==="0")
		{
			var LocID=$("#locId").combobox("getValue");
			var stDate=$("#inputCreateDateStart").datebox("getValue");
			var edDate=$("#inputCreateDateEnd").datebox("getValue");
			var range=$("#checkRange").combobox("getValues").toString();
			var grade=$("#Grade").combobox("getValue");
			if(!validCheck(stDate,edDate)){
				$.messager.alert("��ʾ","��ʼʱ��ӦС�ڽ���ʱ��,����!","info")
				return
			}
			$cm({
				ClassName:"EPRservice.Quality.DataAccess.MedDoctor",
				MethodName:"AddMedDoctor",
				UserId:userId,
				LocID:LocID,
				STDate:stDate,
				EDDate:edDate,
				Range:range,
				Grade:grade,
				dataType:'text'
				
			},function(res){
				if(res==="�ύ�ɹ�")
				{
					$.messager.alert("��ʾ","��ӳɹ�!","info")
					refresh()
				}else
				{
					$.messager.alert("��ʾ","���ʧ��!","info")
				}
			});
		}else
		{
			$.messager.alert("��ʾ","�û���ά���������ظ����!","info")
		}
	});
}

function validCheck(startDate,endDate){
	return startDate<endDate?true:false
}

function rangeFormatter(v)
{
	var newArr=[]
	for(var i=0;i<v.length;i++){
		if(v[i]=="���ڲ���")
		{
			v[i]="IA"
		}
		if(v[i]=="���ﲡ��")
		{
			v[i]="AO"
		}
		if(v[i]=="��ĩ����")
		{
			v[i]="CQC"
		}
		if(newArr.indexOf(v[i])==-1)
		{
			newArr.push(v[i])
		}
	}
	
	return newArr
}


function getRangeValue(target){
	var v=$(target).combobox("getValues")
	
	$(target).combobox("setValues",rangeFormatter(v))
}

function getRangeTexts(v){
	var texts=""
	for(var i=0;i<v.length;i++){

		if(texts=="")
		{
			texts=emrTrans(v[i])	
		}else
		{
			texts=texts+","+emrTrans(v[i])
		}
		
	}
	return texts
}

