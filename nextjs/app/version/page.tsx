const VersionPage = () => {
  // Sample JSON data
  const jsonData = {
      "version": process?.env?.VERSION || "1.0.0",
      "build_sha": process?.env?.BUILD_SHA || "abc57858585",
      "description": process?.env?.DESCRIPTION || "pre-interview technical test"
  };

  // Convert JSON data to a string
  const jsonString = JSON.stringify(jsonData, null, 2);
  
  //console.log(jsonString);
  
  return jsonString;
};

export default VersionPage;
