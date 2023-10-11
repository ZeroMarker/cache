function SaveDataClick()
{
    if(!$('#mainForm').form('validate')){
        $.messager.popover({msg:"请完成必填字段的填写",type:'alert'});
        return;
    }
    var ParID=""
    var row=$('#tabHistory').datagrid('getSelected');
    if(row){
        if((row.InsertDate==CurDate)&&(row.UserDR==session['LOGON.USERID'])){
            ParID=row.ID;
            Save();
        }else{
            $.messager.confirm('提示','所选历史记录非今天本人填写记录,将新增记录,是否继续?',function(r){
                if(r){
                    $('#tabHistory').datagrid('unselectAll');
                    Save();
                }
            });
        }
    }else{
        Save();
    }
    function Save(){
        var SaveObj=new Object();
        $('.frm-table>tbody>tr>td>[id]').each(function(){
            var id=$(this).attr('id');
            if(!id) return true;
            var tagName=$(this).prop("tagName");
            if(tagName=='A') return true;
            if (tagName=="IFRAME"){
                var GetPageDataForOut=$('#'+id)[0].contentWindow.GetPageDataForOut;
                if(typeof GetPageDataForOut!='function'){
                    return true;
                }
                SaveObj[id]=GetPageDataForOut();
            }else{
                var value=$(this).getValue();
                var childClassName=$(this).children().attr('class');
                if(childClassName&&(childClassName.indexOf('kw-section-list')>-1)){
                    value=value.length?value[0].id:'';
                }
                SaveObj[id]=value;
            }
            if(value&&(['SpouseCredNo','IDCardNo'].indexOf(id)>-1)){
                if(!DHCWeb_IsIdCardNo(SaveObj[id])){
                    SaveObj={};
                    return false;
                }
            }
        });
        if(!Object.keys(SaveObj).length){
            return;
        }
        var SaveData=JSON.stringify(SaveObj);
        var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLoc','SaveItem',EpisodeID, PatientID, SpecLocDiagCatID, SaveData, session['LOGON.USERID'],"",ParID,SerialNum);
        var retArr=ret.split("^");
        if(retArr[0]=='0'){
            $.messager.popover({msg:"保存成功",type:'success'});
            $('#tabHistory').datagrid('reload');
            if (websys_showModal('options').CallBackFunc) {
                var MRSpecLocDiagID=retArr[1];
                websys_showModal('options').CallBackFunc(MRSpecLocDiagID);
            }
        }else{
            $.messager.alert('提示','保存失败:'+ret);
        }   
    }
}
function InitHistoryList()
{
    $.cm({
        ClassName:'DHCDoc.Diagnos.SpecLoc',
        MethodName:'GetHistoryColumns',
        CatID:SpecLocDiagCatID,
        rows:99999
    },function(data){
        $.each(data,function(){
            if(['PatType','DangerLevel','BirthControl'].indexOf(this.field)>-1){
                this.formatter=function(value,row,index){
                    return $g(value);
                }
            }else if(this.field=='InsertDate'){
                this.styler=function(value,row,index){
                    if (value==CurDate){
                        return 'color:red;';
                    }
                }
            }else if(this.field=='CurTreat'){
                this.formatter=formatToothData
            }
        });
        data.unshift({field:"BDelete",title:"操作",formatter: function(value,row,index){
                if (row.UserDR==session['LOGON.USERID']){
                    return '<a style="cursor:pointer;" id="BDeleteHistory" onclick="BDeleteHistory('+row.ID+')"></a>';
                }
                return '';
            }
        });
        var columns=new Array();
        columns.push(data);
        $('#tabHistory').datagrid({
            toolbar:[],
            border:false,
            bodyCls:'panel-body-gray',
            fit:true,
            fitColumns:false,
            url:'websys.Broker.cls',
            queryParams:{
                ClassName:'DHCDoc.Diagnos.SpecLoc',
                MethodName:'GetPatHistoryData',
                PatientID:PatientID,
                CatID:SpecLocDiagCatID,
                SerialNum:SerialNum,
                rows:99999
            },
            idField:'ID',
            columns:columns,
            onBeforeSelectOld:function(){},
            onBeforeSelect:function(index,row){
                var selected=$(this).datagrid('getSelected');
                if(selected){
                    var selIndex=$(this).datagrid('getRowIndex',selected);
                    if(selIndex==index){
                        SetDataByRow({});
                        $(this).datagrid('unselectRow',selIndex);
                        return false;
                    }
                }
                return true;
            },
            onSelect:function(index,row){
                SetDataByRow(row);
            },
            onBeforeLoad:function(param){
                var opts=$(this).datagrid('options');
                opts.onBeforeSelectOld=opts.onBeforeSelect;
                opts.onBeforeSelect=function(){};
            },
            onLoadSuccess:function(data){
				ChangeButtonText($("#BDeleteHistory"), "删除", "icon-cancel");
                var opts=$(this).datagrid('options');
                var selected=$(this).datagrid('getSelected');
                setTimeout(function(){
                    if(!selected){
                        $.each(data.rows,function(index,row){
                            if((row.InsertDate==CurDate)){  //&&(row.UserDR==session['LOGON.USERID'])
                                $('#tabHistory').datagrid('selectRow',index);
                                $('body').layout('expand','south');
                                return false;
                            }
                        });
                    }
                    opts.onBeforeSelect=opts.onBeforeSelectOld;
                },100);    
            }
        });
    });
    setTimeout(function(){
        $('.layout-expand-south').find('.panel-title').text($g('历史诊断信息'));
    },800);
}
function SetDataByRow(row)
{
    var keyCnt=Object.keys(row).length;
    $('.frm-table>tbody>tr>td>[id]').each(function(){
        var id=$(this).attr('id');
        if(!id) return true;
        var tagName=$(this).prop("tagName");
        if(tagName=='A') return true;
        var value=(typeof row[id]=='undefined')?'':row[id];
        //传入空设置默认值
        if(!keyCnt){
            if(id=='PatType') value='孕妇';
        }
        if (tagName=="IFRAME"){
            var src=$('#'+id).attr('src');
            //src=src+(src.indexOf('?')>-1?'&':'?')+'initValue='+value;
            if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
            $('#'+id).attr('src',src);
            $('#'+id).attr('value',value);
        }else{
            $('#'+id).setValue(value);
        }
    });
}
function PatTypeClick(item)
{
    if(['孕妇','待产'].indexOf(item.id)>-1){
        $('#LastMenses').datebox({required:true,value:$('#LastMenses').getValue()});
        $('#ExpectBirthDate').datebox({required:true,value:$('#ExpectBirthDate').getValue()});
    }else{
        $('#LastMenses').datebox({required:false,value:$('#LastMenses').getValue()});
        $('#ExpectBirthDate').datebox({required:false,value:$('#ExpectBirthDate').getValue()});
    }
    LastMensesChange($('#LastMenses').getValue());
}
function LastMensesChange(date)
{
    if(date==""){
        $('#ExpectBirthDate,#PregnantWeek').setValue('');
        return;
    }
    if(CompareDate(date,GetCurrentDate())>=0){
        $.messager.popover({msg:"末次月经必须小于今天",type:'error'});
        setTimeout(function(){$('#LastMenses').setValue('');},200);
        return;
    }
    var selects=$('#PatType').getValue();
    if(selects.length&&['孕妇','待产'].indexOf(selects[0].id)>-1){
        $('#ExpectBirthDate').setValue(GetDateAddDays(date,280));
        $('#PregnantWeek').setValue(Math.floor(GetDateDiffDay(GetCurrentDate(),date)/7));
    }
}
function BDeleteHistory(ID)
{
    $.messager.confirm('提示','是否删除此条记录?',function(r){
        if(r){
            var ret=tkMakeServerCall('DHCDoc.Diagnos.SpecLoc','DeleteRecord',ID,session['LOGON.USERID']);
            if(ret=='0'){
                $.messager.popover({msg:"删除成功",type:'success'});
                SetDataByRow({});
                $('#tabHistory').datagrid('unselectAll').datagrid('reload');
            }else{
                $.messager.alert('提示','删除失败:'+ret);
            }
        }
    });
}
//格式化牙位图显示数据
function formatToothData(ToothData,row,index)
{    
	if(!ToothData) return "";
    var ret="";
    if(typeof(ToothData)=='string'){
        try{
            ToothData=JSON.parse(ToothData);
        }catch(e){
            ToothData={};
        }
    }
    $.each(["UpLeftAreaTeeth","UpRightAreaTeeth","DownLeftAreaTeeth","DownRightAreaTeeth"],function(index,value){
        if(!ToothData[value]) return true;
		$.each(ToothData[value],function(){
			var ToothDesc=this.ToothDisplayName;
			var ToothCode=this.ToothCode;
			var SurfaceDesc="",SurfaceCode="";
			var SurfaceData=this.ToothSurfaceItems;
            $.each(SurfaceData,function(){
				SurfaceCode+=this.Code
				if(SurfaceDesc=="") SurfaceDesc=this.ToothSurfaceDisplayName;
				else SurfaceDesc+=","+this.ToothSurfaceDisplayName;
			});
			if(SurfaceDesc!="") ToothDesc+="("+SurfaceDesc+")";
			if(SurfaceCode!="") ToothCode+=SurfaceCode;
			if(ret=="") ret=ToothDesc+"["+ToothCode+"]";
			else ret+="、"+ToothDesc+"["+ToothCode+"]";
        });
	});
	return ret
}
//牙位图数据 提供给电子病历初始化显示调用
function getSelectedToothObj()
{
    $('#CurTreat')[0].contentWindow.$('#addToRecord').hide();
	if(!$('#CurTreat').size()) return {};
	var data=$('#CurTreat').attr('value');
	if(!data) return {}
	return JSON.parse(data);
}
function ChangeButtonText(element, desc, icon) {
    $(element).linkbutton({ iconCls: icon, plain: true });
    $(element).popover({ content: desc, placement: 'top-right', trigger: 'hover' });
}
