// export const businessSignup = async (_: unknown, args: BusinessSignupInput) => {
//   const validatedData = BusinessSignupSchema.parse(args);

//   if (!validatedData) return;

//   return await prisma.$transaction(async (tx) => {
//     let contactConditions: Prisma.BusinessPrimaryContactWhereInput;

//     if (validatedData.email) {
//       contactConditions = {
//         value: validatedData.email,
//         type: "EMAIL",
//         isVerified: true,
//         deletedAt: null,
//       };
//     } else {
//       contactConditions = {
//         value: validatedData.phone,
//         type: "PHONE",
//         isVerified: true,
//         deletedAt: null,
//       };
//     }

//     const existingContact = await tx.businessPrimaryContact.findFirst({
//       where: contactConditions,
//     });

//     if (existingContact) {
//       throw new Error(
//         `A verified business with this ${existingContact.type.toLowerCase()} already exists!`
//       );
//     }

//     if (validatedData.email) {
//       cleanupUnverifiedContacts(tx, validatedData.email, "EMAIL");
//     }
//     if (validatedData.phone) {
//       cleanupUnverifiedContacts(tx, validatedData.phone, "PHONE");
//     }

//     // Generate OTPs
//     // const emailOtpData = validatedData.email ? createOtpData() : null;
//     // const phoneOtpData = validatedData.phone ? createOtpData() : null;

//     const business = await tx.business.create({
//       data: {
//         // name: validatedData.email
//         //   ? validatedData.email.split("@")[0]
//         //   : validatedData.phone,
//       },
//     });

//     const otpExpiresAt = new Date(Date.now() + OTP_EXPIRY_MINUTES * 60 * 1000);

//     let requestId: string | undefined;
//     let reachedIdEmail: string | undefined;
//     let reachedIdPhone: string | undefined;

//     if (validatedData.email && otpExpiresAt) {
//       const response = await sendOtpEmail(
//         business.name,
//         validatedData.email,
//         OTP_EXPIRY_MINUTES
//       );
//       requestId = response.requestId;
//       reachedIdEmail = response.requestId;
//     } else if (validatedData.phone && otpExpiresAt) {
//       const response = await sendOtpPhone(
//         business.name,
//         validatedData.phone,
//         OTP_EXPIRY_MINUTES
//       );
//       requestId = response.requestId;
//       reachedIdPhone = response.requestId;
//     }

//     // Create contacts
//     if (validatedData.email) {
//       await tx.businessPrimaryContact.create({
//         data: {
//           business: {
//             connect: { id: business.id },
//           },
//           type: "EMAIL",
//           value: validatedData.email,
//           isPrimary: true,
//           otp: reachedIdEmail,
//           otpExpiresAt: reachedIdEmail ? otpExpiresAt : null,
//         },
//       });
//     }

//     if (validatedData.phone) {
//       await tx.businessPrimaryContact.create({
//         data: {
//           businessId: business.id,
//           type: "PHONE",
//           value: validatedData.phone,
//           isPrimary: !validatedData.email,
//           otp: reachedIdPhone,
//           otpExpiresAt: reachedIdPhone ? otpExpiresAt : null,
//         },
//       });
//     }

//     return {
//       value: validatedData.email || validatedData.phone,
//       message: `Verification code sent to ${
//         validatedData.email || validatedData.phone
//       }.`,
//       requestId,
//     };
//   });
// };