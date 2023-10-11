var episodeIDStr="";
var GV = {
    _CLASSNAME: "Nur.NIS.Service.SpecManage.CollectRecord"
};
var stepItems=[
	{
		title:$g("�걾����")
	},
	{
		title:$g("Ҫ��ִ��")
	},
	{
		title:$g("�����ӡ")	
	},
	{
		title:$g("ҽ��ִ��")	
	},
	{
		title:$g("�걾�ɼ�"),	
	},
	{
		title:$g("�걾����")	
	}
]
$(function(){	
	initUI();
})

function initUI() {
	//��ʼ��������
	$("#hstp").hstep({
		stepWidth:"21%",
		currentInd:5,
		items:stepItems	
	})	
    $('#updateBtn').bind('click', updateBtnClick);
    $('#labNo').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            updateBtnClick();
        }
    });
    // ����input
    $('#labNo').bind('input onpropertychange', function() {
	    var labNo=$.trim($(this).val());
	    if(labNo.length==10) updateBtnClick();
	});
    
    initTable()
}
/*----------------------------------------------------------------------------------------------------------*/
/**
 * @description ��Ѫʱ����°�ť
 */
function updateBtnClick() {
    var LabEpisodeNo = $('#labNo').val();
    if (LabEpisodeNo !== "") {
	    var UserID = session['LOGON.USERID'];
		var WardID= session['LOGON.WARDID'];
	    var rtn=$cm({
            ClassName: GV._CLASSNAME,
            MethodName: "checkUpdateCollDateTime",
            LabEpisodeNo: LabEpisodeNo,
            UserID: UserID,
			WardID: WardID
        }, false)
        if (rtn.errInfo!=""){
	        if (rtn.specCollFlag==1){
		        $.messager.confirm('ȷ��',rtn.errInfo,function(r){    
				    if (r){    
				         update();
				    }    
				});
				return false;   
		    }else{
			    $.messager.popover({msg:rtn.errInfo,type:'alert'});
			    return false;  
			}
	    }
	    update();
    } else {
        $.messager.popover({ msg: '�����Ϊ��!', type: 'alert' });
        clear();
    }
}
function update(){
	var LabEpisodeNo = $('#labNo').val();
    $('#labNoRead').val(LabEpisodeNo);
    var UserID = session['LOGON.USERID'];
	var WardID= session['LOGON.WARDID'];
	var loginLocId = session['LOGON.CTLOCID'];
    $cm({
        ClassName: GV._CLASSNAME,
        MethodName: "UpdateCollDateTime",
        EpisodeIDStr:episodeIDStr,
        LabEpisodeNo: LabEpisodeNo,
        UserID: UserID,
		WardID: WardID,
		loginLocId: loginLocId
    }, function (jsonData) {
        if (String(jsonData.success) === "0") {
            setStepInfo(jsonData.stepInfo);
            reloadData(jsonData.allLabs);
        }
        else {
            $.messager.popover({msg:jsonData.errInfo,type:'alert'});   
        }
        clear();
    });
}
function clear(){
	//����ı���������ż��ӽ���
	$('#labNo').val("");    
	var object=document.getElementById("labNo");
	object.focus();	
}
/**
 * @description  ���ò�������Ϣ
 * @param {*} jsonData
 */
function setStepInfo(jsonData) {
	stepItems[0].context="<div>"+jsonData.ordDoctor+"</div><div>"+jsonData.ordDateTime.split(" ")[0]+"</div><div>"+jsonData.ordDateTime.split(" ")[1]+"</div>";
	stepItems[1].context="<div>"+jsonData.ordDoctor+"</div><div>"+jsonData.sttDateTime.split(" ")[0]+"</div><div>"+jsonData.sttDateTime.split(" ")[1]+"</div>"
   	if(jsonData.printUser!="" && jsonData.printDateTime!=""){
		stepItems[2].context="<div>"+jsonData.printUser+"</div><div>"+jsonData.printDateTime.split(" ")[0]+"</div><div>"+jsonData.printDateTime.split(" ")[1]+"</div>"   	
	}
	if(jsonData.execNurse!="" && jsonData.execDateTime!=""){
		stepItems[3].context="<div>"+jsonData.execNurse+"</div><div>"+jsonData.execDateTime.split(" ")[0]+"</div><div>"+jsonData.execDateTime.split(" ")[1]+"</div>"   	
	}
	if(jsonData.collUser!="" && jsonData.collDateTime!=""){
		stepItems[4].context="<div>"+jsonData.collUser+"</div><div>"+jsonData.collDateTime.split(" ")[0]+"</div><div>"+jsonData.collDateTime.split(" ")[1]+"</div>"   	
	}
	$("#hstp").html("").hstep({items:stepItems}).css("height","120px");	
}

// ��ʼ��table
function initTable(){ 
	$("#dg").datagrid({
		nowrap:false,  /*�˴�Ϊfalse*/
		toolbar:"#toolbar",
		frozenColumns:[[
			{field:"patName",title:"��������",width:100,wordBreak:'break-all'},
			{field:"regNo",title:"�ǼǺ�",width:100},
			{field:"bedCode",title:"����",width:50},
			{field:"patSex",title:"�Ա�",width:50},
			{field:"patAge",title:"����",width:50},
			{field:"specNum",title:"�걾����",width:70},
			{field:"specName",title:"�걾����",width:120},
			{field:"labNO",title:"�걾��",width:100},
			{field:"arcim",title:"ҽ������",width:300,styler: function(value,row,index){
				if(row.collectStatus=="C"){
					return 'background-color:#f16e57;color:white;';
				}
				if(row.collectStatus=="A"){
					return 'background-color:#2AB66A;color:white;';
				}
				if(row.collectStatus=="U"){
					return 'background-color:#FFB746;color:white;';
				}
				return "";
			}}			
		]],
		columns:[[
			{field:"containerColor",title:"������ɫ",width:70,styler: function(value,row,index){
				return "background-color:"+value;	
			},formatter: function(value,row,index){
				return "";	
			}},
			{field:"containerName",title:"��������",width:120},
			{field:"ordNote",title:"���뱸ע",width:120},
			{field:"sttDateTime",title:"Ҫ��ִ��ʱ��",width:150},
			{field:"collDateTime",title:"��Ѫʱ��",width:150},
			{field:"collUser",title:"��Ѫ��ʿ",width:100},		
		]],
		/*rowStyler:function(index,row){
			if(row.collectStatus=="C"){
				return 'background-color:#f16e57';
			}
			if(row.collectStatus=="A"){
				return 'background-color:#2AB66A';
			}
			if(row.collectStatus=="U"){
				return 'background-color:#FFB746';
			}	
		},*/
		loadMsg : '������..',
		onLoadSuccess:function(data){
			mergeCells();
		}	
	})	
}
function reloadData(data){
	if(data.length>0){
		var array=[];
		var nums=0;
		data.forEach(function(val){
			if(val.collectStatus!="U") nums++;	
			if(array.indexOf(val.episodeID)==-1) array.push(val.episodeID);
		})
		episodeIDStr=array.join("^");
		$("#collectStatus .nums").html(nums);
	}	
	$("#dg").datagrid("loadData",data);	
}

/**
 * @description ����ı���������ż��ӽ���
 */
window.onload=function (){
	var object=document.getElementById("labNo");
	object.focus();	
}
var mergeColumn=["patName",,"regNo","bedCode","patSex","patAge","specNum"];
function mergeCells(){
	var mergeCellsArr=[];
	var otherOrdContCount=0;
	var ordContArr=[];
	var rows=$("#dg").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var episodeID=rows[i].episodeID;
		var containerName=rows[i].containerName;
		var containerColor=rows[i].containerColor;
		if (!containerName) otherOrdContCount++;
		else {
			var index=$.hisui.indexOfArray(ordContArr,"containerName",containerName);
			if (index>=0) {
				ordContArr[index].count=ordContArr[index].count+1;
			}else{
				ordContArr.push({"containerName":containerName,"count":1,"color":containerColor});
			}
		}
		var index=$.hisui.indexOfArray(mergeCellsArr,"episodeID",episodeID);
		if (index>=0){
			mergeCellsArr[index]["mergeRows"]=mergeCellsArr[index]["mergeRows"]+1;
		}else{
			mergeCellsArr.push({"episodeID":episodeID,"mergeRows":1,"index":i});
		}
	}
	for (var i=0;i<mergeCellsArr.length;i++){
		if (mergeCellsArr[i].mergeRows>1){
			$('#dg').datagrid('updateRow',{
				index: mergeCellsArr[i].index,
				row: {
					specNum:mergeCellsArr[i].mergeRows
				}
			})
			for (var j=0;j<mergeColumn.length;j++){
				$('#dg').datagrid('mergeCells',{
					index: mergeCellsArr[i].index,
					field:mergeColumn[j],
					rowspan:mergeCellsArr[i].mergeRows
				});
			}
		}
	}
	if (otherOrdContCount>0){
		ordContArr.push({"containerName":"����","count":otherOrdContCount})
	}
	var ordContInfo="",ordContSum=0;
	for (var i=0;i<ordContArr.length;i++){
		var contObj=ordContArr[i];
		var count=' <span class="num" style="color:'+contObj.color+'">'+contObj.count+'</span>'
		if (ordContInfo=="") ordContInfo=contObj.containerName+count;
		else  ordContInfo=ordContInfo+","+contObj.containerName+count;
		ordContSum=ordContSum+contObj.count;
	}
	if (ordContInfo!="") {
		ordContInfo=ordContInfo+ '�ϼ�:<span class="num">'+ordContSum+'</span>';
		$('#dg').datagrid('insertRow',{
			index: 0,
			row: {
				patName:ordContInfo
			}
		}).datagrid('mergeCells',{
			index: 0,
			field:"patName",
			colspan:9
		});
	}
}