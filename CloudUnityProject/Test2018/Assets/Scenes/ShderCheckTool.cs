using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text.RegularExpressions;

public class ShaderCheckTool : EditorWindow
{


    public Object checkShader;
    //private Shader checkShader;


    [MenuItem("Tools/ShaderCheckTool")]

    static void Toolswindow()
    {
        ShaderCheckTool window = (ShaderCheckTool)EditorWindow.GetWindow(typeof(ShaderCheckTool));
        window.Show();
    }

    public static string shadername;

    private void OnGUI()
    {
        GUILayout.Label("About shader", EditorStyles.boldLabel);
        //EditorGUILayout.BeginHorizontal();
        checkShader = EditorGUILayout.ObjectField(label: "SelectShader", checkShader, typeof(Object), true);
        

        if (checkShader != null)
        {
            shadername = checkShader.ToString();
        }
       

        if (GUILayout.Button("Check"))
        {
            shadername = shadername.Replace("(UnityEngine.Shader)", "");
            shadername = shadername.Trim();

            Listmat();
            Write();
            ListObject();

            Debug.Log("写入成功,写入到" + Application.dataPath + "/MateCheckPath.txt");
            Debug.Log("材质球数量:" + MaterialPath.Count);
            Debug.Log(guid01);
        }

    }

    public static List<string> MaterialPath = new List<string>();
    public static List<Material> Shadermat = new List<Material>();
    public static List<string> Checkshaderpath = new List<string>();

    public static List<string> ObjectPath = new List<string>();
    public static List<GameObject> gameobjectlist = new List<GameObject>();
    public static List<string> objGUID = new List<string>();



    static void Listmat()
    {
        string path = Application.dataPath;
        MaterialPath = new List<string>(Directory.GetFiles(path, "*.mat", SearchOption.AllDirectories)); 
        Checkshaderpath = new List<string>();

        Shader shaderpath = (Shader.Find(shadername));
        string shaderguid =AssetDatabase.GetAssetPath( shaderpath);
        guid01 = AssetDatabase.AssetPathToGUID(shaderguid); //获取shaderGUID

        //for (int i = 0; i < MaterialPath.Count; i++)
        //{
        //    string matpath = MaterialPath[i]; //材质路径.
        //    string[] matArray = matpath.Split('/'); //通过/分块数组
        //    string path01 = matArray[4];

        //    Material[] m_material = new Material[MaterialPath.Count];
        //    //通过包含路径的文件名 将所有的材质球load出来
        //    m_material[i] = AssetDatabase.LoadAssetAtPath<Material>(path01);

        //    if (m_material[i].shader == Shader.Find(shadername))
        //    {
        //        Shadermat.Add(m_material[i]);
        //        Checkshaderpath.Add(path01);
        //    }

        //}

        for (int i = 0; i < MaterialPath.Count; i++)
        {
            string filepath = MaterialPath[i];
            if (Regex.IsMatch(File.ReadAllText(filepath), guid01))
            {
                Checkshaderpath.Add(MaterialPath[i]);
            }
        }




    }
    public static string guid01;
    static void ListObject()
    {
        string path = Application.dataPath;
        ObjectPath = new List<string>(Directory.GetFiles(path, "*.prefab", SearchOption.AllDirectories));

        for (int i = 0; i < ObjectPath.Count; i++)
        {
            string ObjPath = ObjectPath[i]; 
            string[] objArray = ObjPath.Split('/'); 
            string objpath01 = objArray[4];

            GameObject[] gameobjectlist = new GameObject[ObjectPath.Count];

            gameobjectlist[i] = AssetDatabase.LoadAssetAtPath<GameObject>(objpath01);

           var objguid = AssetDatabase.AssetPathToGUID(objpath01);

            // objGUID[i] = gameobjectlist[i].name;
            

            objGUID.Add(objguid);
            


        }
    }

    public void Write()
    {
        FileStream matTxt = new FileStream(Application.dataPath + "/MateCheckPath.txt", FileMode.Create);

        StreamWriter matTxtStreamWriter = new StreamWriter(matTxt);

        matTxtStreamWriter.Write("--------------------------" + "\r\n");
        matTxtStreamWriter.Write("引用到" + shadername + "的材质: " + "\r\n");

        if (Checkshaderpath.Count != 0)
        {
            for (int i = 0; i < Checkshaderpath.Count; i++)
            {
                matTxtStreamWriter.Write(MaterialPath[i] + "\r\n");
            }
        }
        else
        {
            matTxtStreamWriter.Write("没有找到相关引用" + "\r\n");
        }

        matTxtStreamWriter.Write("--------------------------" + "\r\n");

        matTxtStreamWriter.Write("GUID:" + "\r\n");
        for (int i = 0; i < ObjectPath.Count; i++)
        {
            matTxtStreamWriter.Write(objGUID[i] + "\r\n");
        } 

        matTxtStreamWriter.Flush();
        matTxtStreamWriter.Close();
        matTxt.Close();
    }
}
