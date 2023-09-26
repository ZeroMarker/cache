/// ************************************************************
/// * Class Name:	EPRservice.Quality.DataAccess.BOOutSource
/// * Description:	Get data that out of EPR, like HIS or LIS and so on
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-05-10
/// * Version:
/// ************************************************************/
Class EPRservice.Quality.DataAccess.BOOutSource Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "OutSourceInfo";

/// Function:	Get hospital list for some group hospitals
ClassMethod GetHospitals() As EPRservice.dataset.Quality.EHospitalDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EHospitalDataset).%New()
	q result
}

/// Function:	Get security groups of current hospital
ClassMethod GetSSGroups() As EPRservice.dataset.Quality.ESSGroupDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.ESSGroupDataset).%New()
	q result
}

/// Function:	Get department or ward list of current hospital
/// Input:		AType represent department(E) or ward(W)
/// 			ADepartment represent one department,search the wards under <ADepartmentId> used
ClassMethod GetLocations(AType As %String, ADepartmentID As %String) As EPRservice.dataset.Quality.ELocationDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.ELocationDataset).%New()
	d result.SetArgs(AType,ADepartmentID)
	q result
}

/// Function:	Get all doctors under the <ADepartmentId>
/// Input:		ADepartmentId represent the assigned department
ClassMethod GetDoctors(ADepartmentID As %String) As EPRservice.dataset.Quality.EDoctorDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EDoctorDataset).%New()
	d result.SetArgs(ADepartmentID)
	q result
}

/// Function:	Get patient info by <AEpisodeID>
ClassMethod GetPatientInfo(AEpisodeID As %String) As EPRservice.dataset.Quality.EPatientDataset [ WebMethod ]
{
	s result = ##Class(EPRservice.dataset.Quality.EPatientDataset).%New()
	d result.SetArgs(AEpisodeID)
	q result
}

}
