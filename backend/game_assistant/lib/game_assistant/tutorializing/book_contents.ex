defmodule GameAssistant.Tutorializing.BookConents do

# example json:
# "{
#   \"projects\": {
#     \"space smup\": {
#       \"ch1\": {
#         \"scripts/file1\": \"line1;\\nline2;\\nline3;\\nline4;\"
#       },
#       \"ch2\": {
#         \"scripts/file2\": \"brine1;\\nbrine2;\\nbrine3;\\nbrine4;\"
#       }
#     }
#   }
# }"

  def rawContents() do
# PYSTART
   "{\"projects\": {\"Mission Demolition\": {\"Coding the Prototype\": {\"Scripts/Cloud.cs\": \"using System.Collections;\\nusing System.Collections.Generic;\\nusing UnityEngine;\\n\\npublic class Cloud : MonoBehaviour\\n{\\n    [Header(\\\"Set in Inspector\\\")]\\n    public GameObject cloudSphere;\\n    public int numSpheresMin = 6;\\n    public int numSpheresMax = 10;\\n    public Vector3 sphereOffsetScale = new Vector3(5, 2, 1);\\n    public Vector2 sphereScaleRangeX = new Vector2(4, 8);\\n    public Vector2 sphereScaleRangeY = new Vector2(3, 4);\\n\\n\\n    public Vector2 sphereScaleRangeZ = new Vector2(2, 4);\\n    public float scaleYMin = 2f;\\n    private List<GameObject> spheres;\\n    void Start()\\n    {\\n        spheres = new List<GameObject>();\\n        int num = Random.Range(numSpheresMin, numSpheresMax);\\n        for (int i = 0; i < num; i++)\\n        {\\n            GameObject sp = Instantiate<GameObject>(cloudSphere);\\n            spheres.Add(sp);\\n            Transform spTrans = sp.transform;\\n            spTrans.SetParent(this.transform);\\n\\n            Vector3 offset = Random.insideUnitSphere;\\n            offset.x *= sphereOffsetScale.x;\\n            offset.y *= sphereOffsetScale.y;\\n            offset.z *= sphereOffsetScale.z;\\n            spTrans.localPosition = offset;\\n\\n            Vector3 scale = Vector3.one;\\n            scale.x = Random.Range(sphereScaleRangeX.x, sphereScaleRangeX.y);\\n            scale.y = Random.Range(sphereScaleRangeY.x, sphereScaleRangeY.y);\\n            scale.z = Random.Range(sphereScaleRangeZ.x, sphereScaleRangeZ.y);\\n\\n            scale.y *= 1 - (Mathf.Abs(offset.x) / sphereOffsetScale.x);\\n            scale.y = Mathf.Max(scale.y, scaleYMin);\\n            spTrans.localScale = scale;\\n        }\\n    }\\n\\n    void Update()\\n    {\\n        // if (Input.GetKeyDown(KeyCode.Space))\\n        // {\\n        //     Restart();\\n        // }\\n    }\\n    void Restart()\\n    {\\n        foreach (GameObject sp in spheres)\\n        {\\n            Destroy(sp);\\n        }\\n\\n        Start();\\n    }\\n}\\n\", \"Scripts/CloudCrafter.cs\": \"using System.Collections;\\nusing System.Collections.Generic;\\nusing UnityEngine;\\n\\npublic class CloudCrafter : MonoBehaviour\\n{\\n    [Header(\\\"Set in Inspector\\\")]\\n    public int numClouds = 40;\\n    public GameObject cloudPrefab;\\n    public Vector3 cloudPosMin = new Vector3(-50, -5, 10);\\n    public Vector3 cloudPosMax = new Vector3(150, 100, 10);\\n    public float cloudScaleMin = 1;\\n    public float cloudScaleMax = 3;\\n    public float cloudSpeedMult = 0.5f;\\n    private GameObject[] cloudInstances;\\n    void Awake()\\n    {\\n        cloudInstances = new GameObject[numClouds];\\n        GameObject anchor = GameObject.Find(\\\"CloudAnchor\\\");\\n        GameObject cloud;\\n        for (int i = 0; i < numClouds; i++)\\n        {\\n            cloud = Instantiate<GameObject>(cloudPrefab);\\n            Vector3 cPos = Vector3.zero;\\n            cPos.x = Random.Range(cloudPosMin.x, cloudPosMax.x);\\n            cPos.y = Random.Range(cloudPosMin.y, cloudPosMax.y);\\n            float scaleU = Random.value;\\n            float scaleVal = Mathf.Lerp(cloudScaleMin, cloudScaleMax, scaleU);\\n            cPos.y = Mathf.Lerp(cloudPosMin.y, cPos.y, scaleU);\\n            cPos.z = 100 - 90 * scaleU;\\n            cloud.transform.position = cPos;\\n            cloud.transform.localScale = Vector3.one * scaleVal;\\n            cloud.transform.SetParent(anchor.transform);\\n            cloudInstances[i] = cloud;\\n        }\\n    }\\n\\n    void Update()\\n    {\\n        foreach (GameObject cloud in cloudInstances)\\n        {\\n            float scaleVal = cloud.transform.localScale.x;\\n            Vector3 cPos = cloud.transform.position;\\n            cPos.x -= scaleVal * Time.deltaTime * cloudSpeedMult;\\n            if (cPos.x <= cloudPosMin.x)\\n            {\\n                cPos.x = cloudPosMax.x;\\n            }\\n            cloud.transform.position = cPos;\\n        }\\n    }\\n}\", \"Scripts/FollowCam.cs\": \"using System.Collections;\\nusing System.Collections.Generic;\\nusing UnityEngine;\\n\\npublic class FollowCam : MonoBehaviour\\n{\\n    static public GameObject POI;\\n\\n    [Header(\\\"Set in Inspector\\\")]\\n    public float easing = 0.05f;\\n    public Vector2 minXY = Vector2.zero;\\n\\n    [Header(\\\"Set Dynamically\\\")]\\n    public float camZ;\\n\\n    void Awake()\\n    {\\n        camZ = this.transform.position.z;\\n    }\\n\\n    void FixedUpdate()\\n    {\\n        Vector3 destination;\\n        // If there is no poi, return to P:[ 0, 0, 0 ]\\n        if (POI == null)\\n        {\\n            destination = Vector3.zero;\\n        }\\n        else\\n        {\\n            // Get the position of the poi\\n            destination = POI.transform.position;\\n            // If poi is a Projectile, check to see if it\'s at rest\\n            if (POI.tag == \\\"Projectile\\\")\\n            {\\n                // if it is sleeping (that is, not moving)\\n                if (POI.GetComponent<Rigidbody>().IsSleeping())\\n                {\\n                    // return to default view\\n                    POI = null;\\n                    // in the next update\\n                    return;\\n                }\\n            }\\n        }\\n\\n        destination.x = Mathf.Max(minXY.x, destination.x);\\n        destination.y = Mathf.Max(minXY.y, destination.y);\\n        destination = Vector3.Lerp(transform.position, destination, easing);\\n        destination.z = camZ;\\n        transform.position = destination;\\n        Camera.main.orthographicSize = destination.y + 10;\\n    }\\n}\\n\", \"Scripts/Goal.cs\": \"using System.Collections;\\nusing System.Collections.Generic;\\nusing UnityEngine;\\n\\npublic class Goal : MonoBehaviour\\n{\\n    static public bool goalMet = false;\\n    void OnTriggerEnter(Collider other)\\n    {\\n        if (other.gameObject.tag == \\\"Projectile\\\")\\n        {\\n            Goal.goalMet = true;\\n\\n            Material mat = GetComponent<Renderer>().material;\\n            Color c = mat.color;\\n            c.a = 1;\\n            mat.color = c;\\n        }\\n    }\\n}\", \"Scripts/MissionDemolition.cs\": \"using UnityEngine;\\nusing System.Collections;\\nusing UnityEngine.UI;\\npublic enum GameMode\\n{\\n    idle,\\n    playing,\\n    levelEnd\\n}\\npublic class MissionDemolition : MonoBehaviour\\n{\\n    static private MissionDemolition S;\\n    [Header(\\\"Set in Inspector\\\")]\\n    public Text uitLevel;\\n    public Text uitShots;\\n    public Text uitButton;\\n    public Vector3 castlePos;\\n    public GameObject[] castles;\\n    [Header(\\\"Set Dynamically\\\")]\\n    public int level;\\n    public int levelMax;\\n    public int shotsTaken;\\n    public GameObject castle;\\n    public GameMode mode = GameMode.idle;\\n    public string showing = \\\"Show Slingshot\\\";\\n\\n    void Start()\\n    {\\n        S = this;\\n        level = 0;\\n        levelMax = castles.Length;\\n        StartLevel();\\n    }\\n    void StartLevel()\\n    {\\n        if (castle != null)\\n        {\\n            Destroy(castle);\\n        }\\n\\n        GameObject[] gos = GameObject.FindGameObjectsWithTag(\\\"Projectile\\\");\\n        foreach (GameObject pTemp in gos)\\n        {\\n            Destroy(pTemp);\\n        }\\n\\n        castle = Instantiate<GameObject>(castles[level]);\\n        castle.transform.position = castlePos;\\n        shotsTaken = 0;\\n\\n        SwitchView(\\\"Show Both\\\");\\n        ProjectileLine.S.Clear();\\n\\n        Goal.goalMet = false;\\n        UpdateGUI();\\n        mode = GameMode.playing;\\n    }\\n    void UpdateGUI()\\n    {\\n        uitLevel.text = \\\"Level: \\\" + (level + 1) + \\\" of \\\" + levelMax;\\n        uitShots.text = \\\"Shots Taken: \\\" + shotsTaken;\\n    }\\n\\n    void Update()\\n    {\\n        UpdateGUI();\\n        if ((mode == GameMode.playing) && Goal.goalMet)\\n        {\\n            mode = GameMode.levelEnd;\\n\\n            SwitchView(\\\"Show Both\\\");\\n\\n            Invoke(\\\"NextLevel\\\", 2f);\\n        }\\n    }\\n    void NextLevel()\\n    {\\n        level++;\\n        if (level == levelMax)\\n        {\\n            level = 0;\\n        }\\n        StartLevel();\\n    }\\n    public void SwitchView(string eView = \\\"\\\")\\n    {\\n        if (eView == \\\"\\\")\\n        {\\n            eView = uitButton.text;\\n        }\\n        showing = eView;\\n        switch (showing)\\n        {\\n            case \\\"Show Slingshot\\\":\\n                FollowCam.POI = null;\\n                uitButton.text = \\\"Show Castle\\\";\\n                break;\\n            case \\\"Show Castle\\\":\\n                FollowCam.POI = S.castle;\\n                uitButton.text = \\\"Show Both\\\";\\n                break;\\n            case \\\"Show Both\\\":\\n                FollowCam.POI = GameObject.Find(\\\"ViewBoth\\\");\\n                uitButton.text = \\\"Show Slingshot\\\";\\n                break;\\n        }\\n    }\\n\\n    public static void ShotFired()\\n    {\\n        S.shotsTaken++;\\n    }\\n}\", \"Scripts/ProjectileLine.cs\": \"using System.Collections;\\nusing System.Collections.Generic;\\nusing UnityEngine;\\n\\npublic class ProjectileLine : MonoBehaviour\\n{\\n    static public ProjectileLine S;\\n    [Header(\\\"Set in Inspector\\\")]\\n    public float minDist = 0.1f;\\n    private LineRenderer line;\\n    private GameObject _poi;\\n    private List<Vector3> points;\\n    void Awake()\\n    {\\n        S = this;\\n        line = GetComponent<LineRenderer>();\\n        line.enabled = false;\\n        points = new List<Vector3>();\\n    }\\n    public GameObject poi\\n    {\\n        get\\n        {\\n            return (_poi);\\n        }\\n        set\\n        {\\n            _poi = value;\\n            if (_poi != null)\\n            {\\n                line.enabled = false;\\n                points = new List<Vector3>();\\n                AddPoint();\\n            }\\n        }\\n    }\\n    public void Clear()\\n    {\\n        _poi = null;\\n        line.enabled = false;\\n        points = new List<Vector3>();\\n    }\\n\\n    public void AddPoint()\\n    {\\n        Vector3 pt = _poi.transform.position;\\n        if (points.Count > 0 && (pt - lastPoint).magnitude < minDist)\\n        {\\n\\n            return;\\n        }\\n        if (points.Count == 0)\\n        {\\n            Vector3 launchPosDiff = pt - Slingshot.LAUNCH_POS;\\n\\n            points.Add(pt + launchPosDiff);\\n            points.Add(pt);\\n            line.positionCount = 2;\\n            line.SetPosition(0, points[0]);\\n            line.SetPosition(1, points[1]);\\n            line.enabled = true;\\n        }\\n        else\\n        {\\n            points.Add(pt);\\n            line.positionCount = points.Count;\\n            line.SetPosition(points.Count - 1, lastPoint);\\n            line.enabled = true;\\n        }\\n    }\\n    public Vector3 lastPoint\\n    {\\n        get\\n        {\\n            if (points == null)\\n            {\\n                return (Vector3.zero);\\n            }\\n            return (points[points.Count - 1]);\\n        }\\n    }\\n    void FixedUpdate()\\n    {\\n        if (poi == null)\\n        {\\n            if (FollowCam.POI != null)\\n            {\\n                if (FollowCam.POI.tag == \\\"Projectile\\\")\\n                {\\n                    poi = FollowCam.POI;\\n                }\\n                else\\n                {\\n                    return;\\n                }\\n            }\\n            else\\n            {\\n                return;\\n            }\\n        }\\n        AddPoint();\\n        if (FollowCam.POI == null)\\n        {\\n            poi = null;\\n        }\\n    }\\n}\", \"Scripts/RigidbodySleep.cs\": \"using UnityEngine;\\npublic class RigidbodySleep : MonoBehaviour\\n{\\n    void Start()\\n    {\\n        Rigidbody rb = GetComponent<Rigidbody>();\\n        if (rb != null) rb.Sleep();\\n    }\\n}\", \"Scripts/Slingshot.cs\": \"using UnityEngine;\\nusing System.Collections;\\n\\npublic class Slingshot : MonoBehaviour\\n{\\n    static private Slingshot S;\\n\\n    [Header(\\\"Set in Inspector\\\")]\\n    public GameObject prefabProjectile;\\n    public float velocityMult = 8f;\\n\\n\\n    [Header(\\\"Set Dynamically\\\")]\\n    public GameObject launchPoint;\\n    public Vector3 launchPos;\\n    public GameObject projectile;\\n    public bool aimingMode;\\n    private Rigidbody projectileRigidbody;\\n\\n    static public Vector3 LAUNCH_POS\\n    {\\n        get\\n        {\\n            if (S == null) return Vector3.zero;\\n            return S.launchPos;\\n        }\\n    }\\n\\n    void Awake()\\n    {\\n        S = this;\\n        Transform launchPointTrans = transform.Find(\\\"LaunchPoint\\\");\\n        launchPoint = launchPointTrans.gameObject;\\n        launchPoint.SetActive(false);\\n        launchPos = launchPointTrans.position;\\n    }\\n    void OnMouseEnter()\\n    {\\n        launchPoint.SetActive(true);\\n    }\\n    void OnMouseExit()\\n    {\\n        launchPoint.SetActive(false);\\n    }\\n\\n    void OnMouseDown()\\n    {\\n        aimingMode = true;\\n        projectile = Instantiate(prefabProjectile) as GameObject;\\n        projectile.transform.position = launchPos;\\n        projectileRigidbody = projectile.GetComponent<Rigidbody>();\\n        projectileRigidbody.isKinematic = true;\\n    }\\n\\n\\n\\n    void Update()\\n    {\\n        if (!aimingMode) return;\\n        Vector3 mousePos2D = Input.mousePosition;\\n        mousePos2D.z = -Camera.main.transform.position.z;\\n        Vector3 mousePos3D = Camera.main.ScreenToWorldPoint(mousePos2D);\\n        Vector3 mouseDelta = mousePos3D - launchPos;\\n        float maxMagnitude = this.GetComponent<SphereCollider>().radius;\\n        if (mouseDelta.magnitude > maxMagnitude)\\n        {\\n            mouseDelta.Normalize();\\n            mouseDelta *= maxMagnitude;\\n        }\\n\\n        Vector3 projPos = launchPos + mouseDelta;\\n        projectile.transform.position = projPos;\\n        if (Input.GetMouseButtonUp(0))\\n        {\\n            aimingMode = false;\\n            projectileRigidbody.isKinematic = false;\\n            projectileRigidbody.velocity = -mouseDelta * velocityMult;\\n            FollowCam.POI = projectile;\\n            MissionDemolition.ShotFired();\\n            ProjectileLine.S.poi = projectile;\\n            projectile = null;\\n        }\\n    }\\n}\"}}}}"
# PYEND
  end

  def getContents() do
    Jason.decode!(rawContents())
  end
end