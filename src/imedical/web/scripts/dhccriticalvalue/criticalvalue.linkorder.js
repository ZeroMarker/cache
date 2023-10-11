var init=function(){
	$('#list').datagrid({
		//headerCls:'panel-header-gray',
		bodyCls:'panel-header-gray',
        pagination: true,
        striped:true,
        singleSelect:false,
        idField:'ordItemId',
        rownumbers:true,
        toolbar:'#tb',
        url:$URL+'?ClassName=web.DHCAntCVComm&QueryName=LookUpAdmOrder&Adm='+GV.EpisodeID+'',
        queryParams:{
	        q:''
	    },
	    pageSize:20,
	    pageList:[10,20,30,50,100,500],
	    fit:true,
	    fitColumns:true,
	    columns:[[
	    	//ordItemId,ordDesc,ordDateTime,ordLocDesc,ordDoctorName,ordRecLocDesc
	    	{field:'ck',checkbox:true},
	    	{field:'ordDesc',title:'医嘱名称',width:150,formatter:function(val,row){
		    	if (GV.linkedOrdArr.indexOf(row.ordItemId)>-1){
			    	return '<span style="color:red">'+val+'</span>'
			    }else{
				    return val;
				}
		    }},
	    	{field:'ordDateTime',title:'开医嘱时间',width:160},
	    	{field:'ordLocDesc',title:'开医嘱科室',width:150},
	    	{field:'ordDoctorName',title:'开医嘱人',width:100},
	    	{field:'ordRecLocDesc',title:'接收科室',width:150}
	    ]]
	    ,onLoadSuccess:function(data){
		    //$.each(data.rows,function(){
			//    if (GV.linkedOrdArr.indexOf(this.ordItemId)>-1) this.linked=true;
			//})
		    
		},rowStyler:function(ind,row){
			//if (GV.linkedOrdArr.indexOf(row.ordItemId)>-1)  {
			//	return 'background-color:#999;color:#bbb;'
			//}
		},onBeforeCheck:function(ind,row){
			//return !row.linked;	
		},onBeforeSelect:function(ind,row){
			//return !row.linked;	
		}
		
		
	})
	
	var gridState=$.data($('#list')[0], "datagrid");
	if (gridState){
		gridState.checkedRows=GV.ckArr;
		gridState.selectedRows=GV.selArr;
	}
	
	
	
	$('#search').searchbox({
		searcher:function(val){
			$('#list').datagrid('load',{q:val})
		}
	})
	
	$('#btn-ok').linkbutton({
		onClick:function(){
			var rows=$('#list').datagrid('getSelections');
//			var arr=[];
//			if (rows && rows.length>0) {
//				$.each(rows,function(){
//					if (!this.linked) arr.push(this.ordItemId);
//				})
//			}
			var delArr=[],addArr=[];
			$.each(rows,function(){
				if( $.hisui.indexOfArray( GV.oglArr,'ordItemId',this.ordItemId) ==-1 ){ //之前没有的
					
					addArr.push(this);
				}
				
			})
			
			$.each(GV.oglArr,function(){
				if( $.hisui.indexOfArray( rows,'ordItemId',this.ordItemId) ==-1 ){ //之前有现在没有的
					delArr.push(this);
				}
			})
			
			var msgArr=[],addIdArr=[],delIdArr=[];
			if (addArr.length>0) {
				msgArr.push('<span style="color:red">'+ $g('新增关联医嘱：') +'</span>')
				$.each(addArr,function(){
					addIdArr.push( this.ordItemId );
					msgArr.push( this.ordDesc )
				})
			}
			
			if (delArr.length>0) {
				msgArr.push( '<span style="color:red">'+$g('取消关联医嘱：')+'</span>' )
				$.each(delArr,function(){
					delIdArr.push( this.ordItemId );
					msgArr.push( this.ordDesc )
				})
			}
			
			if (msgArr.length>0) {
				$.messager.confirm("确认信息",msgArr.join('<br>'),function(r){
					if(r){
						$.m({
							ClassName:'web.DHCAntCVReportLink',MethodName:'SaveOrDelTransOrd',reportID:GV.reportID,AddIds:addIdArr.join(','),DelIds:delIdArr.join(','),UserID:GV.SessUserId
						},function(ret){
							if (ret>0) {
								$.messager.alert('成功','保存关联医嘱信息成功','success',function(){
									closeWin();	
								})
							}else{
								$.messager.popover({msg:'保存关联医嘱信息失败：'+(ret.split('^')[1]||ret),type:'error'})
							}	
						})	
					}else{
						
						
					}
					
					
					
				})
			
			
			}else{
				$.messager.popover({msg:'没有新增关联医嘱或取消关联医嘱',type:'alert'})
			}
			
		}	
	})
	$('#btn-close').linkbutton({
		onClick:function(){
			closeWin();	
		}	
	})
	
	
	
}
$(function(){
	$.q({ClassName:'web.DHCAntCVReportLink',QueryName:'FindOrd',reportID:GV.reportID,rows:999,ResultSetType:'array'},function(ret){
		GV.linkedOrdArr=[];
		GV.oglArr=[],GV.selArr=[],GV.ckArr=[];
		$.each(ret,function(){
			//lkID,ordItm,ordDesc,ordDoctorName,ordLocDesc,ordDateTime,ordExecNurseName,ordExecDateTime
			//ordItemId,ordDesc,ordDateTime,ordLocDesc,ordDoctorName,ordRecLocDesc
			if (GV.linkedOrdArr.indexOf(this.ordItm)>-1) return true;
			GV.linkedOrdArr.push(this.ordItm);
			var o1={
				ordItemId:this.ordItm,
				ordDesc:this.ordDesc,
				ordDateTime:this.ordDateTime,
				ordDoctorName:this.ordDoctorName,
				ordLocDesc:this.ordLocDesc
			};
			var o2=$.extend({},o1);
			
			GV.oglArr.push(o1);
			
			GV.selArr.push(o2);
			GV.ckArr.push(o2);
			
			
		});
		
		
		init();
	})	
});

function findThisModal(id){
	var modal=null;
	var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
	if (!window.parent || window.parent===window) return modal;
	try {
		var P$=window.parent.$;
	}catch(e){
		return modal;
	}
	if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
	
	window._findThisModalKey=key;
	
	P$('iframe').each(function(){
		try {
			if (this.contentWindow._findThisModalKey==key){
				modal=P$(this).closest('.window-body');
				return false;
			}
		}catch(e){}
		
	})
	return modal;
}

function closeWin(){
	var modal=findThisModal();
	if (modal && modal.length>0){
		modal.window('close');
	}else{
		window.close()
		
	}
	

}