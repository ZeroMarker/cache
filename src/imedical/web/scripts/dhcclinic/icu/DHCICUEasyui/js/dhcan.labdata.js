var lab={
    importLabData:function(opsId){
        this.infectionData=dhccl.runServerMethod("DHCAN.BLL.LabData","GetInfectiousResult",opsId);
        this.bloodTypeData=dhccl.runServerMethod("DHCAN.BLL.LabData","GetBloodType",opsId);
    }
}