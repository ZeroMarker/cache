var operationListConfig={
    actionPermissions:[],
    groupPermissions:[{
        groupID:"29",
        groupName:"住院医师",
        displayColumns:"CheckStatus,OperDate,RoomDesc,OperSeq,PlanOperSeq,PatName,PatGender,PatAge,PatDeptDesc,PrevDiagnosisDesc,PlanOperDesc,SourceTypeDesc,PlanSurgeonDesc,PlanAsstDesc,ScrubNurseDesc,CircualNurseDesc,AnaMethodDesc,AnaDocDesc,InfectionOperDesc,OperPositionDesc,AntibiosisDesc,SurgicalMaterials,HighConsume,OperNote,StatusDesc,DaySurgery",
        operators:[{
            button:"btnCancelOperation",
            status:"Application"
        },{
            button:"btnEditOperation",
            status:"Application"
        }],
        qryConditions:{
            startDate:0,
            endDate:1,
            appDeptEnable:1,
            appDeptDefValue:1
        }
    },{
        groupID:"30",
        groupName:"住院医师主任",
        displayColumns:"CheckStatus,OperDate,RoomDesc,OperSeq,PlanOperSeq,PatName,PatGender,PatAge,PatDeptDesc,PrevDiagnosisDesc,PlanOperDesc,SourceTypeDesc,PlanSurgeonDesc,PlanAsstDesc,ScrubNurseDesc,CircualNurseDesc,AnaMethodDesc,AnaDocDesc,InfectionOperDesc,OperPositionDesc,AntibiosisDesc,SurgicalMaterials,HighConsume,OperNote,StatusDesc,DaySurgery",
        operators:[{
            button:"btnCancelOperation",
            status:"Application,Audit"
        },{
            button:"btnEditOperation",
            status:"Application,Audit"
        }],
        qryConditions:{
            startDate:0,
            endDate:1,
            appDeptEnable:0,
            appDeptDefValue:1
        }
    }],

    getPermission:function(groupID){
        var permissions=this.groupPermissions;
        if(permissions && permissions.length>0){
            for(var i=0;i<permissions.length;i++){
                var permission=permissions[i];
                if(permission.groupID===groupID){
                    return permission;
                }
            }
        }
        return null;
    },

    getOperPermission:function(groupID,operButton,status){
        var permission=this.getPermission(groupID);
        if(permission && permission.operators && permission.operators.length>0){
            for(var i=0;i<permission.operators.length;i++){
                var operator=permission.operators[i];
                if(operator.button===operButton && operator.status.indexOf(status)>=0){
                    return true;
                }
            }
        }
        return false;
    },

    getActionPermission:function(groupID,moduleID,elementID){
        if(this.actionPermissions.length<1){
            this.actionPermissions=dhccl.getDatas(ANCSP.DataQuery,{
                ClassName:ANCLS.BLL.ConfigQueries,
                QueryName:"FindActionPermission",
                Arg1:groupID,
                Arg2:moduleID,
                Arg3:"Y",
                ArgCnt:3
            },"json");
        }

        var _actionPermissions=this.actionPermissions
        function getActionPermssionByID(elID){
            var result=null;
            if(_actionPermissions && _actionPermissions.length>0){
                for(var actionIndex=0;actionIndex<_actionPermissions.length;actionIndex++){
                    permission=_actionPermissions[actionIndex];
                    if(permission.ElementID===elID){
                        result=permission;
                    }
                }
            }
            return result;
        }

        var ret=getActionPermssionByID(elementID);
        return ret;
    }
}
