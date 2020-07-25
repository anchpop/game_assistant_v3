using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dray : MonoBehaviour
{
    [Header("Set in Inspector")]
    public float speed = 5;

    [Header("Set Dynamically")]
    public int dirHeld = -1; // Direction of the held movement key

    private Rigidbody   rigid;
    private Animator    anim;                                            // a


    private Vector3[] directions = new Vector3[] {
        Vector3.right, Vector3.up, Vector3.left, Vector3.down };             // a

    private KeyCode[] keys = new KeyCode[] { KeyCode.RightArrow,
        KeyCode.UpArrow, KeyCode.LeftArrow, KeyCode.DownArrow };             // a


    void Awake()
    {
        rigid = GetComponent<Rigidbody>();
        anim = GetComponent<Animator>();                                     // a
    }

    void Update()
    {
        dirHeld = -1;
        // Delete the four "if ( Input.GetKey..." lines that were here
        for (int i = 0; i < 4; i++)
        {
            if (Input.GetKey(keys[i])) dirHeld = i;                        // b
        }

        Vector3 vel = Vector3.zero;
        // Delete the entire switch clause that used to be here
        if (dirHeld > -1) vel = directions[dirHeld];                         // b


        rigid.velocity = vel * speed;

        // Animation
        if (dirHeld == -1)
        {                                                 // b
            anim.speed = 0;
        }
        else
        {
            anim.CrossFade("Dray_Walk_" + dirHeld, 0);                       // c
            anim.speed = 1;
        }
    }
}
