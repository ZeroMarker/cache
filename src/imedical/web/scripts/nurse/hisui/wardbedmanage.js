/**
 * @author songchao 
 * @description 病区床位管理界面 20180710
 */

var GV = {
    ClassName: "Nur.InService.WardBedManage"
}
/*-----------------------------------------------------------*/
var init = function () {
    initPage()
    initEvent();
    initData();
}
$(init)
/*-----------------------------------------------------------*/
/**
 * @description 元素绑定事件
 */
function initEvent() {
    $('#confirmReleaseBtn').click(confirmReleaseBtnClick);
	$('#closeDlgBtn').click(function(){$('#releaseDlg').dialog('close')});
}
/**
 * @description 初始化数据
 */
function initData() {
    //findWardBed();
    initBedGrid();
}
/**
 * @description 初始化页面元素
 */
function initPage() {
	 var wardID=session['LOGON.WARDID'];
    $('#wardBedGrid').datagrid({
		url:$URL + '?ClassName='+GV.ClassName+'&QueryName=FindWardBed'+'&WardID='+wardID,
		pageSize:100,
		pageList : [100,200],
		autoSizeColumn:false,
		rownumbers:true,
		pagination:true,
		iconCls:'icon-bed',
        toolbar: [{
            iconCls: 'icon-lock',
            text:'锁定',
            handler: lockSelectBeds
        },{
            iconCls: 'icon-unlock',
            text:'解锁',
            handler: unlockSelectBeds
        }],
        rowStyler: function(index,row){
            if (row.BedStatus=="空床"){
                return 'background-color:#A7DE40;';
            }
            else if (row.BedStatus=="已预约"){
                return 'color:red;';
            }
        },
        onClickCell:function(rowIndex, field, value){
	        if ((field=="bedTypeDesc")||(field=="bedRoomDesc")){
		        $('#wardBedGrid').datagrid("beginEdit",rowIndex);
		    }
	    }
    });
}
/**
 * @description 批量锁定选中的床位
 */
function lockSelectBeds(){
    var selectRows=$('#wardBedGrid').datagrid('getSelections');
    var bedArray=[];
    selectRows.forEach(function(row){ 
        if(row.BedStatus=="空床"){
            bedArray.push(row.BedId);
        }
    });
    if(bedArray.length==0){
        $.messager.popover({msg:$g("请选中空床状态的床位进行锁定"),type:'alert'});
         return;
    }
    var userID=session['LOGON.USERID'];
    $cm({
        ClassName:GV.ClassName,
        MethodName:"lockBeds",
        BedIDStr:bedArray.join("^"),
        UserID:userID
    },function(jsonData){
        if(jsonData.success=='0'){
            $.messager.popover({msg:$g('床位锁定成功！'),type:'success'});
            findWardBed();
        }else{
            $.messager.popover({msg:$g('锁定失败！')+jsonData.errInfo,type:'error'});
        }
    })
}
/**
 * @description 批量解锁选中的床位
 */
function unlockSelectBeds(){
    var selectRows=$('#wardBedGrid').datagrid('getSelections');
    var bedArray=[];
    selectRows.forEach(function(row){ 
        if(row.BedStatus=="锁定"){
            bedArray.push(row.BedId);
        }
    });
    if(bedArray.length==0){
        $.messager.popover({msg:$g('请选中锁定状态的床位进行解锁!'),type:'alert'});
        return;
    }
    var userID=session['LOGON.USERID'];
    $cm({
        ClassName:GV.ClassName,
        MethodName:"unlockBeds",
        BedIDStr:bedArray.join("^"),
        UserID:userID
    },function(jsonData){
        if(jsonData.success=='0'){
            $.messager.popover({msg:$g('床位锁定成功！'),type:'success'});
            findWardBed();
        }else{
            $.messager.popover({msg:jsonData.errInfo,type:'error'});
        }
    })
}

/**
 * @description 查询病区床位
 */
function findWardBed(){
    var wardID=session['LOGON.WARDID'];
	$('#wardBedGrid').datagrid('reload');
    /*$cm({
        ClassName: GV.ClassName,
        QueryName: "FindWardBed",
        ResultSetType: 'array',
        WardID: wardID
    }, function (jsonData) {
        $('#wardBedGrid').datagrid({ data: jsonData });
        if (jsonData.length > 0) {
            $('#wardBedGrid').datagrid({ title: '床位列表：' + jsonData[0].wardDesc });
        }
    })*/
}

/**
 * @description 床位列表行操作按钮(分配,取消分配)
 * @param {} val 
 * @param {*} row 
 * @param {*} index 
 */
function bedGridRowOper(val, row, index) {
    var btns="";
    if(row.BedSexDesc=="不限"){
        btns = '<a href="#" class="maleBtn fa fa-male fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'M' + '\')"></a>'   // + '\',\'' + String(row.TransCount) 
            +'<a href="#" class="femaleBtn fa fa-female fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'F' + '\')"></a>'
    }else if(row.BedSexDesc=="男床"){
        btns = '<a href="#" class="notCareSexBtn fa fa-intersex fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'' + '\')"></a>'
            +'<a href="#" class="femaleBtn fa fa-female fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'F' + '\')"></a>'
    }else if(row.BedSexDesc=="女床"){
        btns = '<a href="#" class="notCareSexBtn fa fa-intersex fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'' + '\')"></a>'
            +'<a href="#" class="maleBtn fa fa-male fa-lg rowBtnLocation" onclick="sexBtnClick(\'' + String(row.BedId)+ '\',\'' +'M' + '\')"></a>'   // + '\',\'' + String(row.TransCount) 
    }
    if(row.BedStatus=="锁定"){
        btns=btns+'<a href="#" class="unlockBtn fa fa-unlock fa-lg rowBtnLocation" onclick="unlockBtnClick(\'' + String(row.BedId) + '\')"></a>';
    }
    else if(row.BedStatus=="空床"){
        btns=btns+'<a href="#" class="lockBtn fa fa-lock fa-lg rowBtnLocation" onclick="lockBtnClick(\'' + String(row.BedId) + '\')"></a>';
    }
    else if(row.BedStatus=="占用"){
        if(row.EmptyDate==""){
            btns=btns+'<a href="#" class="releaseBtn fa fa-bed fa-lg rowBtnLocation" onclick="releasBtnClick(\'' + String(row.BedId) + '\')"></a>';
        }else{
            btns=btns+'<a href="#" class="cancelReleaseBtn fa fa-bed fa-lg rowBtnLocation" onclick="cancelReleaseBtnClick(\'' + String(row.BedId) + '\')"></a>';
        }
        
    }else if(row.BedStatus=="释放"){
	    btns=btns+'<a href="#" class="cancelReleaseBtn fa fa-bed fa-lg rowBtnLocation" onclick="cancelReleaseBtnClick(\'' + String(row.BedId) + '\')"></a>';
	}
    return btns;
}

/**
 *@description 初始化bedGrid按钮操作及事件监听等
 *
 */
function initBedGrid() {
    $('#wardBedGrid').datagrid('getColumnOption', 'Operate').formatter = bedGridRowOper;
    if (bedSetting.allowModifyBedType=="Y"){
	    $('#wardBedGrid').datagrid('getColumnOption', 'bedTypeDesc').editor = {
		    type:'combobox',  
			options:{
				url:$URL+"?ClassName=web.DHCBL.CT.PACBedType&QueryName=GetDataForCmb1&rows=999999",
				valueField:'BEDTPRowId',
				textField:'BEDTPDesc',
				required:false,
				onBeforeLoad:function(param){
					param = $.extend(param,{rowid:"",code:"",desc:"",hospid:session['LOGON.HOSPID']});
				},
				loadFilter:function(data){
				    return data['rows'];
				},
				onSelect:function(rec){
	                if (rec){
		                var tr = $(this).closest("tr.datagrid-row");
						var index = tr.attr("datagrid-row-index");
						var rows=$('#wardBedGrid').datagrid("getRows");
						$m({
					        ClassName:GV.ClassName,
					        MethodName:"changeBedType",
					        BedID:rows[index].BedId,
					        bedTypeId:rec.BEDTPRowId
					    },function(txtData){
					        if(txtData!="0"){
					            $.messager.popover({msg:txtData,type:'error'});
					        }else{
					            $.messager.popover({msg:$g("床位类型修改成功！"),type:'success'});
					            findWardBed();
					        }
					    });
		            }
				}
			  }
		};
	}
	if (bedSetting.allowModifyBedRoom=="Y"){
		$('#wardBedGrid').datagrid('getColumnOption', 'bedRoomDesc').editor = {
		    type:'combobox',  
			options:{
				url:$URL+"?ClassName=web.DHCBL.CT.PACRoom&QueryName=GetDataForCmb1&rows=999999",
				valueField:'ROOMRowID',
				textField:'ROOMDesc',
				required:false,
				onBeforeLoad:function(param){
					param = $.extend(param,{rowid:"",code:"",desc:"",hospid:session['LOGON.HOSPID']});
				},
				loadFilter:function(data){
				    return data['rows'];
				},
				onSelect:function(rec){
					if (rec){
		                var tr = $(this).closest("tr.datagrid-row");
						var index = tr.attr("datagrid-row-index");
						var rows=$('#wardBedGrid').datagrid("getRows");
						$m({
					        ClassName:GV.ClassName,
					        MethodName:"changeBedRoom",
					        BedID:rows[index].BedId,
					        bedRoomId:rec.ROOMRowID
					    },function(txtData){
					        if(txtData!="0"){
					            $.messager.popover({msg:txtData,type:'error'});
					        }else{
					            $.messager.popover({msg:$g("房间修改成功！"),type:'success'});
					            findWardBed();
					        }
					    });
		            }
				}
			  }
		};
	}
    /*$('#wardBedGrid').datagrid({
        onLoadSuccess: function () {
            $('.notcareSexBtn').linkbutton({ plain: true, iconCls: 'fa fa-venus-mars fa-lg rowBtnLocation' });
            $('.maleBtn').linkbutton({ plain: true, iconCls: 'fa fa-male fa-lg rowBtnLocation' });
            $('.femaleBtn').linkbutton({ plain: true, iconCls: 'fa fa-female fa-lg rowBtnLocation' });
            $('.lockBtn').linkbutton({ plain: true, iconCls: 'fa fa-lock fa-lg rowBtnLocation' });
            $('.unlockBtn').linkbutton({ plain: true, iconCls: 'fa fa-unlock fa-lg rowBtnLocation' });
            $('.releaseBtn').linkbutton({ plain: true, iconCls: 'fa fa-bed fa-lg rowBtnLocation' });
            $('.cancelReleaseBtn').linkbutton({ plain: true, iconCls: 'fa fa-bed fa-lg rowBtnLocation' });
        }
    });*/
}
/**
 * 锁定床位
 * @param {*} bedID 
 */
function lockBtnClick(bedID){
    var userID=session['LOGON.USERID'];
    $m({
        ClassName:GV.ClassName,
        MethodName:"lockBed",
        BedID:bedID,
        UserID:userID
    },function(txtData){
        if(txtData!="0"){
            $.messager.popover({msg:txtData,type:'error'});
        }else{
            $.messager.popover({msg:$g("床位锁定成功！"),type:'success'});
            findWardBed();
        }
    });
}
/**
 * 解锁床位
 * @param {*} bedID 
 */
function unlockBtnClick(bedID){
    var userID=session['LOGON.USERID'];
    $m({
        ClassName:GV.ClassName,
        MethodName:"unlockBed",
        BedID:bedID,
        UserID:userID
    },function(txtData){
        if(txtData!="0"){
            $.messager.popover({msg:txtData,type:'error'});
        }else{
            $.messager.popover({msg:$g("床位解锁成功！"),type:'success'});
            findWardBed();
        }
    });
}
/**
 * 改变床位性别按钮监听
 * @param {*} bedID 
 * @param {*} sexCode 
 */
function sexBtnClick(bedID,sexCode){
    changeSex(bedID,sexCode);
}
/**
 * @description 变更床位性别
 * @param {*} bedID 
 * @param {*} sexCode 
 */
function changeSex(bedID,sexCode){
    $m({
        ClassName:GV.ClassName,
        MethodName:"changeBedSex",
        BedID:bedID,
        SexCode:sexCode
    },function(txtData){
        if(txtData!="0"){
            $.messager.popover({msg:txtData,type:'error'});
        }else{
            $.messager.popover({msg:$g("床位性别修改成功！"),type:'success'});
            findWardBed();
        }
    });
}

/**
 * @description 释放床位
 * @param {*} bedID 
 */
function releasBtnClick(bedID){
    $('#releaseDlg').dialog({queryParams:{BedID:bedID}});
    $('#releaseDlg').dialog('open');    
    var opt=$("#releaseDateBox").datebox('options');
    opt.minDate = opt.formatter(new Date()); 
    $('#releaseDateBox').datebox('setValue', formatDate(new Date()));
}
/**
 * 确认释放
 */
function confirmReleaseBtnClick(){
    var options=$('#releaseDlg').dialog('options');
    var bedID=options.queryParams.BedID;
    var date=$('#releaseDateBox').datebox('getValue');
    var userID=session['LOGON.USERID'];
    $m({
        ClassName:GV.ClassName,
        MethodName:"releaseBed",
        BedID:bedID,
        Date:date,
        UserID:userID
    },function(txtData){
        if(txtData=='0'){            
            $('#releaseDlg').dialog('close');   
            findWardBed(); 
            $.messager.popover({msg:$g('释放成功!'),type:'success'});
        }else{
            $('#releaseDlg').dialog('close'); 
            findWardBed();
            $.messager.popover({msg:$g('释放失败:')+txtData,type:'error'});
        }
    })
}
/**
 * @description 取消释放
 * @param {*} bedID 
 */
function cancelReleaseBtnClick(bedID){
    var userID=session['LOGON.USERID'];
    $m({
        ClassName:GV.ClassName,
        MethodName:"cancelReleaseBed",
        BedID:bedID,
        UserID:userID
    },function(txtData){
        if(txtData=='0'){     
            findWardBed();        
            $.messager.popover({msg:$g('取消释放成功!'),type:'success'});
        }else{
            findWardBed();
            $.messager.popover({msg:$g('取消释放失败:')+txtData,type:'error'});
        }
    })
}
function translateFormate(value,row,index){
	return $g(value)
}