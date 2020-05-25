import fsplayer.api.ICompanyLogo;

interface fsplayer.api.ICompanyInfo
{
	/*
	Indicates whether the company has logo
	*/
	function hasLogo():Boolean;
	
	/*
	Returns the ICompanyLogo interface providing information about company logotype
	*/
	function getLogo():ICompanyLogo;
}
